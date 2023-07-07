using dt_aareon_emmen.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace dt_aareon_emmen.Controllers
{
	public class Sensor : Controller
	{
		private readonly IHttpContextAccessor _httpContextAccessor;

		private SensorM sensorM;

		private readonly ILogger<Sensor> _logger;
		public Sensor(ILogger<Sensor> _logger, ILogger<Building> B_logger, ILogger<Room> _roomlogger, IConfiguration _configuration, IHttpContextAccessor _httpContextAccessor)
		{
			this._logger = _logger;
			this._httpContextAccessor = _httpContextAccessor;
			this.sensorM = new SensorM(_configuration);
		}

		[Route("Sensor/Index/{id:int}")]
		[Authorize(Policy = "mfa")]
		// GET: /Sensor/Index/(buildingId)
		public ActionResult Index(int id)
		{
			// Retrieve the JWT token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Extract the user's role from the JWT token
			ViewBag.role = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			// Get the list of sensors for the specified building
			ViewBag.sensors = sensorM.GetSensors(id);
			ViewBag.buildingId = id;

			// Create a dictionary containing the building ID for generating the buildingIdPath
			ViewBag.buildingIdPath = new List<Dictionary<string, string>>
				{
					new Dictionary<string, string> { { "id", id.ToString() } }
				};
			ViewBag.buildingName = sensorM.GetBuildingName(id).First()["name"];

			// Check if there is an error message in TempData
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Return the Index view
			return View("Index");
		}


		[Route("Sensor/Edit/{buildingId:INT}/{friendlyname}")]
		[Authorize(Policy = "mfa")]
		// GET: /Sensor/Edit/(building id)/(friendlyname)
		public ActionResult Edit(int buildingId, string friendlyname)
		{
			// Retrieve the JWT token from the session
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			ViewBag.role = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

			List<Dictionary<string, string>> sensor = sensorM.GetSensor(friendlyname);
			List<Dictionary<string, string>> sensor_types = this.sensorM.GetSensorTypes();
			List<Dictionary<string, string>> rooms = this.sensorM.GetRoomsByBuildingId(buildingId);



			// Check if the sensor was successfully retrieved
			if (sensor.Count == 0)
			{
				TempData["error"] = "De sensor kon niet worden ingeladen";
				return View("Edit");
			}

			// Assign the sensor information and other necessary data to the ViewBag properties
			ViewBag.sensor = sensor.First();
			ViewBag.sensorTypes = sensor_types;
			ViewBag.buildingId = buildingId;
			ViewBag.rooms = rooms;


			// Check if there is an error message in TempData
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			// Return the Edit view
			return View("Edit");
		}

		// Delete a sensor
		[Route("Sensor/DeleteSensor/{buildingId}/{friendlyname}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: /Sensor/DeleteSensor/(buildingId)/(friendlyname)
		public IActionResult DeleteSensor(int buildingId, string friendlyname)
		{
			try
			{
				sensorM.RemoveSensor(friendlyname);
				TempData["success"] = "Sensor is succesvol verwijderd";
			}
			catch (Exception ex)
			{
				// Log the error and store an error message in TempData.
				TempData["error"] = "Sensor: " + friendlyname + " kon niet verwijderd worden. Verwijder eerst de Facilitor koppeling.";
				_logger.LogError("Sensor: " + friendlyname + " kon niet verwijderd worden | : " + ex.Message);
			}
			// Redirect to the Index action of the Sensor controller with the buildingId parameter.
			return RedirectToAction("Index", "Sensor", new { id = buildingId });
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: Sensor/Edit
		public ActionResult Update(IFormCollection collection, int buildingId, string friendlyname)
		{
			try
			{
				if (string.IsNullOrEmpty(collection["room_nr"]) ||
					string.IsNullOrEmpty(collection["sensor_type"]))
				{
					// Set an error message in TempData and redirect to the Edit action of the Sensor controller.
					TempData["error"] = "Niet alle velden zijn ingevuld";
					return RedirectToAction("Edit", "Sensor", new { buildingId = buildingId, friendlyname = friendlyname });
				}
				_logger.LogInformation("Amount of rooms found: " + sensorM.FindRoom(collection["room_nr"]).Count);

				if (sensorM.FindRoom(collection["room_nr"]).Count == 0)
				{
					TempData["error"] = "Er kon geen kamer gevonden worden met het nummer: \"" + collection["room_nr"] + "\"";
					return RedirectToAction("Edit", "Sensor", new { buildingId = buildingId, friendlyname = friendlyname });
				}

				if (!sensorM.EditSensor(friendlyname, collection["room_nr"], collection["serial"], int.Parse(collection["sensor_type"])))
				{
					_logger.LogError("Sensor not edited");
					TempData["error"] = "De sensor kon niet worden aangepast";
				}
				else
				{
					TempData["success"] = "Sensor is succesvol aangepast";
				}
			}
			catch (Exception ex)
			{
				_logger.LogError("Er is een onbekende fout opgetreden: " + ex.Message);
				TempData["error"] = "Er is een onbekende fout opgetreden";
			}

			// Redirect to the Edit action of the Sensor controller.
			return RedirectToAction("Edit", "Sensor", new { buildingId = buildingId, friendlyname = friendlyname });
		}

		[Route("Sensor/Create/{buildingId}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// GET: Building/Create/1
		public IActionResult Create(int buildingId)
		{
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			ViewBag.role = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);
			if (!(sensorM.BuildingIdExists(buildingId)))
			{
				return View("Error");
			}

			// Check if there is an error message in TempData and pass it to the view
			if (TempData["error"] != null)
			{
				TempData["error"] = TempData["error"].ToString();
			}

			// Get the rooms and sensor types for the specified buildingId
			List<Dictionary<string, string>> rooms = this.sensorM.GetRooms(buildingId);
			List<Dictionary<string, string>> sensor_types = this.sensorM.GetSensorTypes();
			List<Dictionary<string, string>> data_types = this.sensorM.GetDataTypesFacilitor();

			// Check if there are rooms available
			if (!(rooms.Count == 0))
			{
				ViewBag.rooms = rooms;
				ViewBag.sensorTypes = sensor_types;
				ViewBag.datatypes = data_types;
				ViewBag.buildingId = buildingId;
			}
			else
			{
				return View("Error");
			}

			// Return the Create view
			return View("Create");
		}

		[Route("Sensor/Create/{buildingId}")]
		[HttpPost]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		// POST: Sensor/Create - adds sensor to the database
		public IActionResult CreateSensor(IFormCollection collection, int buildingId)
		{
			// Check if any of the required fields are empty
			if (string.IsNullOrEmpty(collection["friendlyName"]) || string.IsNullOrEmpty(collection["roomNumber"]) || string.IsNullOrEmpty(collection["serialNumber"]) || string.IsNullOrEmpty(collection["typeId"]))
			{
				TempData["error"] = "Niet alle velden zijn ingevuld";
				return RedirectToAction("Create", new { buildingId = buildingId });
			}

			try
			{
				//sensorM.AddSensor(collection["roomNumber"], collection["friendlyName"], collection["serialNumber"], int.Parse(collection["typeId"]), buildingId);
				//TempData["success"] = "Sensor is succesvol toegevoegd";

				if (!string.IsNullOrWhiteSpace(collection["facilitorKey"]))
				{
					if (!int.TryParse(collection["facilitorKey"], out int facilitorKeyId))
					{
						TempData["error"] = "Ongeldige waarde voor Facilitor key";
						return RedirectToAction("Create", new { buildingId = buildingId });
					}

					if (this.sensorM.CheckIfFacilitorKeyExists(facilitorKeyId))
					{
						TempData["error"] = "Facilitor key bestaat niet, vul een andere key in";
						return RedirectToAction("Create", new { buildingId = buildingId });
					}

					try
					{
						sensorM.AddSensor(collection["roomNumber"], collection["friendlyName"], collection["serialNumber"], int.Parse(collection["typeId"]), buildingId);
						sensorM.AddFacilitorKeyToSensor(collection["friendlyName"], facilitorKeyId, int.Parse(collection["dataTypeId"]));

						TempData["success"] = "Sensor en Facilitor key zijn succesvol toegevoegd";
						return RedirectToAction("Create", new { buildingId = buildingId });
					}
					catch (Exception e)
					{
						TempData["error"] = "Er is iets fout gegaan met het toevoegen van de Facilitor key, probeer het opnieuw";
						return RedirectToAction("Create", new { buildingId = buildingId });
					}
				}
				else
				{
					try
					{
						sensorM.AddSensor(collection["roomNumber"], collection["friendlyName"], collection["serialNumber"], int.Parse(collection["typeId"]), buildingId);
						TempData["success"] = "Sensor is succesvol toegevoegd";

						return RedirectToAction("Create", new { buildingId = buildingId });
					}
					catch (Exception e)
					{
						TempData["error"] = "Er is iets fout gegaan, probeer het opnieuw";
						return RedirectToAction("Create", new { buildingId = buildingId });
					}
				}
			}
			catch (Exception e)
			{
				TempData["error"] = "Er is iets fout gegaan, probeer het opnieuw";
				return RedirectToAction("Create", new { buildingId = buildingId });
			}

		}
	}
}
