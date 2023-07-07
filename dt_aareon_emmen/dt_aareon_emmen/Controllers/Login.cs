using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using dt_aareon_emmen.Models;
using dt_aareon_emmen.Models.Assets;
using Microsoft.AspNetCore.Authorization;
using MySqlX.XDevAPI;

namespace dt_aareon_emmen.Controllers
{
	public class Login : Controller
	{

		// LOGGER to log on different log levels, configuration which contains everything there is in appsettings.json, used in both constructors
		private readonly ILogger<Login> _logger;
		private readonly IConfiguration _configuration;
		private readonly IHttpContextAccessor _httpContextAccessor;
		private ISession _session => _httpContextAccessor.HttpContext.Session;
		private Mail mail;
		private LoginM login;

		public Login(ILogger<Login> _logger, IConfiguration _configuration, IHttpContextAccessor httpContextAccessor)
		{
			this._logger = _logger;
			this._configuration = _configuration;
			this._httpContextAccessor = httpContextAccessor;
			this.mail = new Mail(this._configuration, this._logger);
			this.login = new LoginM(this._logger, this._configuration);
		}

		// The following attribute ensures that only users with the "mfaAndLogin" policy are authorized to access this action.
		[Authorize(Policy = "mfaAndLogin")]
		// GET: Login
		public ActionResult Index()
		{
			// Check if there is an error message stored in TempData
			if (TempData["error"] != null)
			{
				// Retrieve the error message from TempData and store it in the ViewBag
				ViewBag.error = TempData["error"].ToString();
			}
			
			// Return the View for the Index page
			return View();
		}

		// The following attributes ensure that only users with the "login" and "mfaAndLogin" policies are authorized to access this action.
		[Authorize(Policy = "login")]
		[Authorize(Policy = "mfaAndLogin")]
		// GET: mfa action
		public ActionResult mfa()
		{
			// Check if there is an error message stored in TempData
			if (TempData["error"] != null)
			{
				// Retrieve the error message from TempData and store it in the ViewBag
				ViewBag.error = TempData["error"].ToString();
			}
			
			// Return the View for the mfa page
			return View();
		}

		// POST: Login/SubmitLogin
		[HttpPost("login")]
		[ValidateAntiForgeryToken]
		public ActionResult SubmitLogin(IFormCollection collection)
		{
			// Retrieve the email and password from the form collection
			string mail = collection["mail"];
			string passwordHashed = Hash.ComputeSHA256(collection["password"]);
			
			// Retrieve user records based on the provided email and hashed password
			List<Dictionary<string, string>> result = this.login.GetUserRecord(mail.ToLower(), passwordHashed);

			// Check if user records were found
			if (result != null)
			{
				if (result.Count > 0)
				{
					// Check if the password and email match the retrieved user records
					if (result[0]["password"].Equals(passwordHashed) && result[0]["mail"].Equals(mail.ToLower()))
					{
						// Retrieve full user records for the authenticated user
						List<Dictionary<string, string>> user = this.login.GetFullUserRecord(mail.ToLower(), passwordHashed);
						// Create a token for the user
						string token = CreateToken(user);
						// Store the token in the session
						HttpContext.Session.SetString("Token", token);
						
						// Check if Multi-Factor Authentication (MFA) is required for the user
						if (MfaCreate(mail.ToLower()))
						{
							return RedirectToAction("mfa");
						}
						else
						{
							TempData["error"] = "Er is iets misgegaan";
							return RedirectToAction("index");
						}
					}
				}
			}
			TempData["error"] = "Onjuist wachtwoord of emailadres";
			return RedirectToAction("Index");
		}

		// Function to create an MFA token
		// Note: This code assumes that the "login" policy is required for accessing this function
		[Authorize(Policy = "login")]
		private string CreateMfaToken(string value)
		{
			// Retrieve the symmetric security key and signing credentials from the configuration
			SymmetricSecurityKey securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
			SigningCredentials credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

			// Create a claim for the authentication type with the provided value
			Claim[] claims = new[]
			{
				new Claim(ClaimTypes.Authentication, value)
			};

			// Create a JWT security token with the issuer, audience, claims, expiration, and signing credentials
			JwtSecurityToken token = new JwtSecurityToken(
				_configuration["Jwt:Issuer"],
				_configuration["Jwt:Audience"],
				claims,
				expires: DateTime.Now.AddMinutes(120),
				signingCredentials: credentials);

			// Return the JWT token as a string
			return new JwtSecurityTokenHandler().WriteToken(token);
		}

		// Private function to create a token
		private string CreateToken(List<Dictionary<string, string>> user)
		{
			// Retrieve the symmetric security key and signing credentials from the configuration
			SymmetricSecurityKey securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
			SigningCredentials credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

			// Create an array of claims for the token, including name identifier, email, role, and authentication status
			Claim[] claims = new[]
			{
				new Claim(ClaimTypes.NameIdentifier, user[0]["username"]),
				new Claim(ClaimTypes.Email, user[0]["mail"]),
				new Claim(ClaimTypes.Role, user[0]["role_id"]),
				new Claim(ClaimTypes.Authentication, "false")
			};

			// Create a JWT security token with the issuer, audience, claims, expiration, and signing credentials
			JwtSecurityToken token = new JwtSecurityToken(
				_configuration["Jwt:Issuer"],
				_configuration["Jwt:Audience"],
				claims,
				expires: DateTime.Now.AddMinutes(120),
				signingCredentials: credentials);

			// Return the JWT token as a string
			return new JwtSecurityTokenHandler().WriteToken(token);
		}

		// Action method to handle the error page
		public IActionResult Error()
		{
			// Set the error message to be displayed in the view
			ViewBag.Message = "An error occurred...";

			// Return the Error view
			return View();
		}


		[Authorize(Policy = "login")]
		public Boolean MfaCreate(string email)
		{
			// string mfaToken = PasswordGenerator.RandomPassword(10); // uncomment

			// string message = @$"
			// <!DOCTYPE html>
			// <html>

			// <head>
			// 		<title>2-Factor Authenticatie</title>
			// 		<meta charset='UTF-8'>
			// 		<meta name='viewport' content='width=device-width, initial-scale=1.0'>
			// </head>

			// <body style='background-color: #000; color: #fff; font-family: Arial, sans-serif;'>
			// 		<table cellpadding='0' cellspacing='0' border='0' align='center' width='600' style='margin: 0 auto;'>
			// 				<tr>
			// 						<td>
			// 								<table cellpadding='20' cellspacing='0' border='0' width='100%'>
			// 										<tr>
			// 												<td style='background-color: #222; padding: 40px;'>
			// 														<h2 style='margin: 0; color: white'>2-Factor Authenticatie</h2>
			// 												</td>
			// 										</tr>
			// 										<tr>
			// 												<td style='background-color: #111; padding: 40px;'>
			// 														<p style='margin-bottom: 10px;'>Beste gebruiker, </p>
			// 														<p style='margin: 0;'>Gebruik de volgende 2FA code om in te loggen op de 
			// 																<a href='https://10.200.0.205:443' target='_blank'>
			// 																		Aareon digital twin
			// 																</a> omgeving:
			// 														</p>
			// 														<div style='padding: 10px 20px; border-radius: 5px; display: inline-block; margin-top: 20px;'>
			// 																<span style='color: #fff; font-weight: bold; font-size: 22px; text-align: center'>{mfaToken}</span>
			// 														</div>
			// 														<p>
			// 																<small>
			// 																		Als je deze authenticatie code niet hebt aangevraagd, negeer dan deze e-mail.
			// 																</small>
			// 														</p>
			// 												</td>
			// 										</tr>
			// 								</table>
			// 						</td>
			// 				</tr>
			// 		</table>
			// </body>

			// </html>";

			// login.SetMultiFactorAuthKey(email, mfaToken);
			// if (mail.SendMail(email, "Aareon digital twin - 2FA Token", message))
			// {
			//    return true;
			// }
			// return false;

			string mfaToken = "test";
			login.SetMultiFactorAuthKey(email, mfaToken);
			return true;
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult MfaCheck(IFormCollection collection)
		{
			// Get the session token from the current session
			string sessionToken = HttpContext.Session.GetString("Token");

			// Read the JWT token from the session token
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);

			// Extract the user's email from the JWT token
			string mail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Email).Value;

			// Get the MFA token input from the form collection
			string token = collection["mfa-input"].ToString().Trim();

			if (string.IsNullOrEmpty(token))
			{
				TempData["error"] = "Onjuiste mfa token";
				return RedirectToAction(nameof(mfa));
			}

			// Retrieve the user's MFA token from the database
			List<Dictionary<string, string>> dbToken = login.GetUserMfaToken(mail);
			string mfaToken = dbToken[0]["mfa_token"];

			// Compare the user input MFA token with the token stored in the database
			if (mfaToken.Equals(token))
			{
				// Create an MFA token for the user
				string generatedMfaToken = CreateMfaToken("True");

				// Store the MFA token in the current session
				HttpContext.Session.SetString("MfaToken", generatedMfaToken);

				// Clear the MFA token stored in the database
				login.SetMultiFactorAuthKey(mail, "");

				// Redirect the user to the desired page (e.g., Building Index)
				return RedirectToAction("Index", "Building");
			}
			else
			{
				TempData["error"] = "Onjuiste mfa token.";
				return RedirectToAction(nameof(mfa));
			}
		}
	}
}