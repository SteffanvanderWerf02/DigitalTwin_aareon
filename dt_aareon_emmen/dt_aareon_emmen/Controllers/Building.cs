using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using dt_aareon_emmen.Models;
using Microsoft.Extensions.Logging;
using System.Configuration;
using Microsoft.AspNetCore.Authorization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Diagnostics;

namespace dt_aareon_emmen.Controllers
{
	public class Building : Controller
	{
		private readonly ILogger<Building> _logger;
		private readonly IConfiguration _configuration;
		private readonly IHttpContextAccessor _httpContextAccessor;

		private BuildingM building;

		public Building(ILogger<Building> _logger, IConfiguration _configuration, IHttpContextAccessor httpContextAccessor)
		{
			this._logger = _logger;
			this._configuration = _configuration;
			this._httpContextAccessor = httpContextAccessor;
			this.building = new BuildingM(this._logger, this._configuration);
		}

		// The following line ensures that only users with the "mfa" policy are authorized to access this action.
		[Authorize(Policy = "mfa")]
		// GET: Index page
		public ActionResult Index()
		{
			// Retrieve the authentication token from the session.
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT (JSON Web Token) from the token string.
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Extract the user role from the JWT claims and store it in the ViewBag.
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Retrieve the list of buildings and store it in the ViewBag.
			ViewBag.buildings = building.GetBuildings();

			// Set the error message on the index page
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Return the Index view for the GET request.
			return View();
		}

		// The following route is used to handle GET requests to the Building Map with a specific ID.
		// GET: Building/Map/(number)
		[Route("Building/Map/{id:int}")]
		[Authorize(Policy = "mfa")]
		public ActionResult Map(int id, string startDate, string endDate)
		{
			// Retrieve the authentication token from the session.
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT (JSON Web Token) from the token string.
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Extract the user role from the JWT claims and store it in the ViewBag.
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Store the building ID in the ViewBag for reference in the view.
			ViewBag.buildingId = id;

			// Retrieve the list of rooms for the given building ID and store it in the ViewBag.
			ViewBag.rooms = building.GetRoomsByBuildingId(id);

			// Retrieve the room number and name for the given building ID and store it in the ViewBag.
			ViewBag.roomNumName = building.GetRoomNumNameById(id);

			// Retrieve the room coordinates and name for the given building ID and store it in the ViewBag.
			ViewBag.roomCoordinatesName = building.GetRoomCoordinatesName(id);

			// Retrieve the map associated with the building ID and store it in the ViewBag.
			ViewBag.map = building.GetMapFromBuilding(id);

			// Retrieve the name of the building associated with the building ID and store it in the ViewBag.
			ViewBag.building = building.GetBuildingName(id);

			if (startDate != null && endDate != null)
			{
				ViewBag.startDate = startDate;
				ViewBag.endDate = endDate;

				ViewBag.motionData = building.GetHistoryMotionInBetween(id, startDate, endDate);
				ViewBag.co2TempHumidityData = building.GetHistoryCo2InBetween(id, startDate, endDate);
			}

			return View();
		}

		// POST: Building/Map/(number)
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Export(IFormCollection collection)
		{
			// Split the query string into startDate and endDate
			string queryString = collection["datetimes"];
			int separatorIndex = queryString.IndexOf(" - ");
        	string startDate = queryString.Substring(0, separatorIndex);
        	string endDate = queryString.Substring(separatorIndex + 3);

			// Construct the query string
        	string constructedQueryString = $"?startDate={startDate.Replace(" ", "%20")}&endDate={endDate.Replace(" ", "%20")}";

			//Get building id from submit button
			return Redirect("/Building/Map/1" + constructedQueryString);
		}

		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: Building/Create page
		public ActionResult Create()
		{
			// Check if there is an error message stored in TempData and pass it to the ViewBag if present.
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Retrieve the authentication token from the session.
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT (JSON Web Token) from the token string.
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Extract the user role from the JWT claims and store it in the ViewBag.
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Return the Create view for the GET request.
			return View();
		}

		// The following attributes indicate that this action is meant to handle HTTP POST requests.
		[HttpPost]
		[ValidateAntiForgeryToken]
		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: Building/Create
		public ActionResult Create(IFormCollection collection)
		{
			// Check if any files are present in the collection.
			if (collection.Files != null)
			{
				// Check if any required fields are missing.
				if (string.IsNullOrEmpty(collection["name"]) || string.IsNullOrEmpty(collection["type"]) || string.IsNullOrEmpty(collection["company"]) || string.IsNullOrEmpty(collection["retention_period"]) || collection.Files["mapimage"] == null)
				{
					TempData["error"] = "Niet alle velden zijn ingevuld";
					return RedirectToAction(nameof(Create));
				}

				// Check if the map image file has an allowed MIME type.
				if (collection.Files["mapimage"] != null && !IsAllowedMimeType(collection.Files["mapimage"]))
				{
					TempData["error"] = "De plattegrond kon niet worden geüpload, probeer een .PNG, .JPG of .GIF";
					return RedirectToAction(nameof(Create));
				}

				// Check if the map image file has an allowed MIME type.
				if (!building.AddBuilding(collection, IsAllowedMimeType(collection.Files["image"])))
				{
					TempData["error"] = "De plattegrond kon niet worden geüpload";
					return RedirectToAction(nameof(Create));
				}
			}
			else
			{
				TempData["error"] = "Er zijn geen bestanden geüpload";
			}

			TempData["success"] = "Gebouw is succesvol toegevoegd";
			return RedirectToAction(nameof(Create));
		}

		// The following route is used to handle GET requests to the Edit page with a specific ID.
		[Route("Building/Edit/{id:int}")]
		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: Building/Edit/(number)
		public ActionResult Edit(int id)
		{
			// Check if the building ID exists, and set ViewBag.buildingExists accordingly.
			if (!(building.BuildingIdExists(id)))
			{
				ViewBag.buildingExists = true;
			}

			// Check if there is an error message stored in TempData and pass it to the ViewBag if present.
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Retrieve the authentication token from the session.
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");

			// Read the JWT (JSON Web Token) from the token string.
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Extract the user role from the JWT claims and store it in the ViewBag.
			ViewBag.role = Int32.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Retrieve the single building information for the given ID and store it in the ViewBag.
			ViewBag.singleBuilding = building.EditGetSingleBuilding(id);

			// Return the Edit view for the GET request.
			return View();
		}

		// The following attributes indicate that this action is meant to handle HTTP POST requests.
		[HttpPost]
		[ValidateAntiForgeryToken]
		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: Building/Edit
		public ActionResult Update(IFormCollection collection)
		{
			// Parse the building ID from the form collection.
			int id = int.Parse(collection["id"]);

			try
			{
				// Check if any required fields are missing.
				if (string.IsNullOrEmpty(collection["name"]) || string.IsNullOrEmpty(collection["type"]) || string.IsNullOrEmpty(collection["company"]) || string.IsNullOrEmpty(collection["retention"]))
				{
					TempData["error"] = "Niet alle velden zijn ingevuld";
					return RedirectToAction("Edit", "Building", new { id });
				}

				// Check if the retention field contains only digits.
				if (!int.TryParse(collection["retention"], out _))
				{
					TempData["error"] = "De retentieperiode mag alleen cijfers bevatten";
					return RedirectToAction("Edit", "Building", new { id });
				}

				// Check if the retention field exceeds the maximum allowed length.
				if (collection["retention"].ToString().Length > 3)
				{
					TempData["error"] = "De retentieperiode mag maximaal 3 cijfers bevatten";
					return RedirectToAction("Edit", "Building", new { id });
				}

				if (collection.Files != null && collection.Files.Count > 0)
				{
					if (collection.Files["image"] != null)
					{
						if (!IsAllowedMimeType(collection.Files["image"]))
						{
							TempData["error"] = "De gebouw afbeelding is geen .PNG, .JPG of .GIF";
							return RedirectToAction("Edit", "Building", new { id });
						}
					}

					if (collection.Files["mapimage"] != null)
					{
						if (!IsAllowedMimeType(collection.Files["mapimage"]))
						{
							TempData["error"] = "De plattegrond afbeelding is geen .PNG, .JPG of .GIF";
							return RedirectToAction("Edit", "Building", new { id });
						}
					}
				}

				// Update the building using the provided form collection.
				building.EditBuilding(collection);
				
				TempData["success"] = "Gebouw is succesvol bijgewerkt";
				return RedirectToAction("Edit", "Building", new { id });
			}
			catch (Exception ex)
			{
				TempData["error"] = "Er is een onbekende fout opgetreden";
				return RedirectToAction("Edit", "Building", new { id });
			}
		}

		// The following route is used to handle requests to the Delete page with a specific ID.
		[Route("Building/Delete/{id:int}")]
		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: Building/Delete/(number)
		public ActionResult Delete(int id)
		{
			// Remove the building with the given ID.
			try
			{
				building.RemoveBuilding(id);
				TempData["success"] = "Gebouw is succesvol verwijderd";
			} catch (Exception e)
			{
				TempData["error"] = "Gebouw kon niet verwijderd worden, er zijn nog ruimtes en/of sensoren gekoppeld aan het gebouw";
			}
			return RedirectToAction("Index");
		}

		// The following attributes indicate that this action is meant to handle HTTP POST requests.
		[HttpPost]
		[ValidateAntiForgeryToken]
		// The following lines ensure that only users with the "Admin" and "mfa" policies are authorized to access this action.
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: Building/Delete/5
		public ActionResult Delete(int id, IFormCollection collection)
		{
			try
			{
				// Redirect to the Index page after the POST request is processed.
				return RedirectToAction(nameof(Index));
			}
			catch
			{
				// In case of an error, return the default View.
				return View();
			}
		}

		// Check if the MIME type of the file is allowed
		public bool IsAllowedMimeType(IFormFile file)
		{
			// Define an array of allowed MIME types
			string[] allowedMimeTypes = { "image/png", "image/jpeg", "image/gif" };
			string[] allowedExtentions = { ".jpg", ".jpeg", ".png", ".gif" };

			// Check if a file is provided
			if (file != null)
			{
				// Iterate through each allowed MIME type
				foreach (var mimeType in allowedMimeTypes)
				{
					// Check if the file's MIME type matches the current allowed MIME type
					if (file.ContentType == mimeType)
					{
						foreach (var extention in allowedExtentions)
						{
							if (Path.GetExtension(file.FileName).ToLower().Equals(extention))
							{
								return true;
							}
						}

					}
				}
			}

			// The file's MIME type or extension is not allowed
			return false;
		}
	}
}
