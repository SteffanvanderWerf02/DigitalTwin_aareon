using dt_aareon_emmen.Models;
using dt_aareon_emmen.Models.Assets;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace dt_aareon_emmen.Controllers
{
	public class User : Controller
	{
		// LOGGER to log on different log levels, configuration which contains everything there is in appsettings.json, used in both constructors
		private readonly ILogger<User> _logger;
		private readonly IConfiguration _configuration;
		private readonly IHttpContextAccessor _httpContextAccessor;
		private Mail mail;
		private UserM user;

		public User(ILogger<User> _logger, IConfiguration _configuration, IHttpContextAccessor httpContextAccessor)
		{
			this._logger = _logger;
			this._configuration = _configuration;
			this._httpContextAccessor = httpContextAccessor;
			this.mail = new Mail(this._configuration, this._logger);
			this.user = new UserM(this._logger, this._configuration);
		}

		// Retrieves the currently logged-in user based on the HttpContext and user claims
		private UserM GetCurrentUser(IHttpContextAccessor httpContextAccessor, ILogger<User> _logger, IConfiguration _configuration)
		{
			// Get the identity from the HttpContext
			ClaimsIdentity identity = httpContextAccessor.HttpContext.User.Identity as ClaimsIdentity;

			if (identity != null)
			{
				// Retrieve the user claims
				IEnumerable<Claim> userClaims = identity.Claims;

				// Create a new instance of UserM with the retrieved claims
				return new UserM(_logger, _configuration)
				{
					UserName = userClaims.First().Value, // Assuming the first claim represents the UserName
					Email = userClaims.First().Value, // Assuming the first claim represents the Email
					Role = userClaims.First().Value // Assuming the first claim represents the Role
				};
			}

			return null;
		}
		
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "mfa")]
		// POST: User/ChangePassword
		public ActionResult ChangePassword(IFormCollection collection)
		{
			// Get the session token from the HttpContext session
			string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");
			
			// Read the JWT token from the session token
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
			
			// Extract the email from the JWT token claims
			string mail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Email).Value;
			
			// Hash the current and new passwords
			string currentPwHashed = Hash.ComputeSHA256(collection["current-password"]);
			string newPwHashed = Hash.ComputeSHA256(collection["new-pw"]);
			string newPwRepeatHashed = Hash.ComputeSHA256(collection["new-pw-repeat"]);

			// Validate the new password against the Validate.ValidatePassword() method in the "Models/Assets" directory
			if (Validate.ValidatePassword(collection["new-pw"]).GetResult())
			{
				// Check if the new password is the same as the current password
				if (currentPwHashed.Equals(newPwHashed))
				{
					TempData["error"] = "Het nieuwe wachtwoord mag niet hetzelfde zijn als het oude wachtwoord";
					return RedirectToAction("Password");
				}
				
				// Check if the new passwords match
				if (!newPwHashed.Equals(newPwRepeatHashed))
				{
					TempData["error"] = "Het nieuwe wachtwoord moet gelijk zijn aan het herhaal wachtwoord";
					return RedirectToAction("Password");
				}

				// Retrieve the user's password from the database
				string dbPassword = this.user.GetCurrentUserPassword(mail)[0]["password"];

				// Check if the returned password is not null
				if (dbPassword != null)
				{
					// Check if the database password matches the current password and if its length is greater than 0
					if (dbPassword.Equals(currentPwHashed) && dbPassword.Length > 0)
					{
						// Update the user's password in the database based on the email address and the new password
						if (this.user.UpdatePassword(mail, newPwHashed))
						{
							// Redirect the user to the building overview page
							return RedirectToAction("Index", "Building");
						}
					}
				}
			}
			else
			{
				TempData["error"] = Validate.ValidatePassword(collection["new-pw"]).GetMessage();
				return RedirectToAction("Password");
			}
			
			// Redirect the user to the password page
			return RedirectToAction("Password");
		}

		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: User
		public ActionResult Index()
		{
			// Retrieve the JWT token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT token and parse its claims
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Retrieve the user's role from the JWT claims and convert it to an integer
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Retrieve the list of users
			ViewBag.users = user.GetUsers();

			return View();
		}

		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: User/Details/5
		public ActionResult Details(int id)
		{
			return View();
		}

		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: User/Create
		public IActionResult Create()
		{
			// Retrieve the JWT token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			
			// Read the JWT token and extract the role claim
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Check if there is an error message in TempData and assign it to ViewBag.error
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Retrieve the roles from the user object and assign them to ViewBag.roles
			ViewBag.roles = user.GetRoles();

			// Return the "Create" view
			return View();
		}

		[Authorize(Policy = "mfa")]
		// GET: User/Password (edit password)
		public ActionResult Password()
		{
			return View();
		}

		[HttpPost]
		[Authorize(Policy = "mfa")]
		// POST: User/Profile (edit profile)
		public ActionResult ChangeProfile(IFormCollection collection)
		{
			try
			{
				// Retrieve the username and session token from the form collection and session
				string name = collection["username"];
				string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");

				// Read the JWT token and extract the email claim
				JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
				string mail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Email).Value;

				// Validate if the name is not empty
				if (string.IsNullOrEmpty(name))
				{
					TempData["error"] = "De gebruikersnaam is leeg";
					return RedirectToAction("Profile");
				}

				// Call the user's ChangeProfile method to update the username
				if (!user.ChangeProfile(name, mail))
				{
					TempData["error"] = "De gebruikersnaam kon niet worden aangepast";
					return RedirectToAction("Profile");
				}
			}
			catch (Exception e)
			{
				TempData["error"] = "Er is iets fout gegaan";
			}

			return RedirectToAction("Profile");
		}

		[Authorize(Policy = "mfa")]
		//GET: User/Profile
		public ActionResult Profile()
		{
			try
			{
				// Retrieve the session token from the session
				string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");

				// Read the JWT token and extract the email claim
				JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
				string mail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Email).Value;

				// Retrieve the user data from the database based on the email
				List<Dictionary<string, string>> userData = this.user.GetProfile(mail);

				// Set the ViewBag properties for displaying the user data in the view
				ViewBag.mail = userData[0]["mail"];
				ViewBag.username = userData[0]["username"]; // get username from the database
				ViewBag.error = TempData["error"];

				return View();
			}
			catch (Exception ex)
			{
				return RedirectToAction("Error");
			}
		}

		[Authorize(Policy = "mfa")]
		// GET: User/Profile (edit profile)
		public ActionResult Settings()
		{
			// Retrieve the session token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT token and extract the role claim
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			return View();
		}

		[HttpGet("settings")]
		// GET: User/settings (edit profile)
		public IActionResult ClearSession()
		{
			// Retrieve the session token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT token and extract the role claim
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);
			
			// Clear the session
			HttpContext.Session.Clear();

			// Redirect to the "Index" action
			return RedirectToAction("Index");
		}

		// Create a user
		[Route("User/CreateUser")]
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: User/CreateUser
		public IActionResult CreateUser(IFormCollection collection)
		{
			// Check if the required fields are filled
			if (string.IsNullOrEmpty(collection["name"]) || string.IsNullOrEmpty(collection["email"]))
			{
				TempData["error"] = "Niet alle velden zijn ingevuld";
				return RedirectToAction("Create");
			}

			// Check if the name contains only alphabetical characters
			if (!Validate.IsAlphabetical(collection["name"]))
			{
				TempData["error"] = "De naam mag alleen alfabetische karakters bevatten";
				return RedirectToAction("Create");
			}

			// Validate the email format
			if (!user.IsValidEmail(collection["email"]))
			{
				TempData["error"] = "Het opgegeven emailadres is ongeldig";
				return RedirectToAction("Create");
			}

			try
			{
				string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");  // updated to session of user
				var jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
				string currentUserEmail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Email).Value;

				// Generate random 15-character password
				string password = PasswordGenerator.RandomPassword(15);

				// Hash the password and add user info to the database
				string hashedPassword = Hash.ComputeSHA256(password);
				user.CreateUser(collection["name"], collection["email"], collection["rol"], hashedPassword);

				// Send email with the generated password to the new user
				if (mail.SendMail(collection["email"].ToString(), $"Wachtwoord gebruiker : {collection["name"]}", $"Hi {collection["name"]}, <br> <br> Je wachtwoord is <strong>{password}</strong>"))
				{
					// Send notification email to the current user about the new user account creation
					mail.SendMail(currentUserEmail, $"Aangemaakte gebruiker : {collection["name"]}", $"Er is een account aangemaakt voor de gebruiker {collection["email"]} <br> met de gebruikersnaam {collection["name"]}.");
				}

				TempData["success"] = "De gebruiker is succesvol toegevoegd";

				// Return to index page
				return RedirectToAction("Create");
			}
			catch (MySql.Data.MySqlClient.MySqlException)
			{
				// if the mysql query fails, return the user to the create form.
				TempData["error"] = "Er is iets fout gegaan, probeer het opnieuw";
				return RedirectToAction("Create");
			}
		}

		// Edit user form
		[Route("User/Edit/{email}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public IActionResult Edit(string email)
		{
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			if (!(user.IsValidEmail(email)))
			{
				// Set ViewBag property to indicate invalid email
				ViewBag.InvalidEmail = true;
			}
			else
			{
				var userInfo = user.GetUser(email);
				if (userInfo.Count == 0)
				{
					// Set ViewBag property to indicate non-existing email
					ViewBag.InvalidEmail = true;
				}
			}

			// Get the user information and the roles to display them on the edit form.
			ViewBag.roles = user.GetRoles();
			ViewBag.email = email;
			ViewBag.info = user.GetUser(email);

			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			return View();
		}
	
		[Route("User/Update")]
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: User/update
		public IActionResult Update(IFormCollection collection)
		{
			// Check if the required fields are filled
			if (string.IsNullOrEmpty(collection["naam"]) || string.IsNullOrEmpty(collection["role"]))
			{
				TempData["error"] = "Niet alle velden zijn ingevuld";  // Set error message
				return RedirectToAction("Edit", new { email = collection["email"] });  // Redirect to the "Edit" action with email parameter
			}
			else if (!Validate.IsAlphabetical(collection["naam"]))
			{
				TempData["error"] = "De naam mag alleen alfabetische karakters bevatten";  // Set error message
				return RedirectToAction("Edit", new { email = collection["email"] });  // Redirect to the "Edit" action with email parameter
			}
			else if (!user.RoleExists(collection["role"]))
			{
				TempData["error"] = "De opgegeven rol bestaat niet";
				return RedirectToAction("Edit", new { email = collection["email"] });
			}
			else
			{
				// Update user information in the database
				this.user.EditUser(collection["email"], collection["naam"], collection["role"]);
				TempData["success"] = "De gebruiker is succesvol bijgewerkt";
				return RedirectToAction("Edit", new { email = collection["email"]} );
			}
		}

		// Delete a user
		[Route("User/Delete/{email}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// Delete a user.
		public IActionResult Delete(string email)
		{
			try
			{
				// Delete user based on email address.
				this.user.DeleteUser(email);
				TempData["success"] = "De gebruiker is succesvol verwijderd";
				return RedirectToAction("Index");
			}
			catch (Exception)
			{
				// If an exception occurs, redirect to the index page
				return RedirectToAction("Index");
			}
		}
	}
}
