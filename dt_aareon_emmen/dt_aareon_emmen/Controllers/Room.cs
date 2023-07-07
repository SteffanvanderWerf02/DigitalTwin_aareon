using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using dt_aareon_emmen.Models;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using System.Data;
using System.IdentityModel.Tokens.Jwt;

namespace dt_aareon_emmen.Controllers
{
    public class Room : Controller
    {
        // LOGGER to log on different log levels, configuration which contains everything there is in appsettings.json, used in both constructors
        private readonly ILogger<Room> _logger;
        private readonly IConfiguration _configuration;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private RoomM room;

        public Room(ILogger<Room> _logger, IConfiguration _configuration, IHttpContextAccessor _httpContextAccessor)
        {
            this._logger = _logger;
            this._configuration = _configuration;
            this._httpContextAccessor = _httpContextAccessor;
            this.room = new RoomM(this._logger, this._configuration);
        }

		// GET: Room
		[Route("/room/index/{buildingId:int}/{roomNum}")]
		[Authorize(Policy = "mfa")]
		public ActionResult Index(int buildingId, string roomNum)
		{
			// add the data to the viewBag to show on the View
			ViewBag.roominfo = room.GetRoomInformation(buildingId, roomNum);
			ViewBag.mSensor = room.GetRoomMotionsensors(buildingId, roomNum);
			ViewBag.cSensor = room.GetRoomCo2sensors(buildingId, roomNum);
			ViewBag.data = room.GetRoomData(buildingId, roomNum);
			ViewBag.history = $"/room/history/{buildingId}/{roomNum}";
			ViewBag.buildingId = buildingId;
			ViewBag.roomNum = roomNum;

			return View();
		}

        // GET: /Room/Overview/(buildingId)
		[Route("Room/Overview/{id:int}")]
		[Authorize(Policy = "mfa")]
		public ActionResult Overview(int id)
		{
			//Create token for auth
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			// Add data to the Viewbag to show on the view
		    ViewBag.role = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);
            ViewBag.rooms = room.GetRooms(id);
			ViewBag.buildingId = id;
			
			//get the path to the building
			ViewBag.buildingIdPath = new List<Dictionary<string, string>>
			{
				new Dictionary<string, string> { { "id", id.ToString() } }
			};
			ViewBag.buildingName = room.GetBuildingName(id).First()["name"];

			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			return View("Overview");
		}

		// "/room/History/{buildingId:int}/{roomNum}?startDate=<OPTIONAL1>&endDate=<OPTIONAL2>" 
		[Route("/room/History/{buildingId:int}/{roomNum}")]
		[Authorize(Policy = "mfa")]
		public ActionResult History(int buildingId, string roomNum, string startDate, string endDate)
		{
			//get room history information
			ViewBag.roomDetails = room.GetRoomInformation(buildingId, roomNum);
			ViewBag.BuildingName = room.GetBuildingName(buildingId);
			if (string.IsNullOrEmpty(startDate) || string.IsNullOrEmpty(endDate))
			{
				DateTime day = DateTime.Today.Date;
				ViewBag.data = room.GetHistory(buildingId, roomNum, day);
			}
			else
			{
				//add data to viewbag
				ViewBag.startDate = startDate;
				ViewBag.endDate = endDate;
				ViewBag.motionData = room.GetHistoryMotionInBetween(buildingId, roomNum, startDate, endDate);
				ViewBag.co2TempHumidityData = room.GetHistoryCo2InBetween(buildingId, roomNum, startDate, endDate);
			}

			return View();
		}

		// GET: Room/Details/5
		[Authorize(Policy = "mfa")]
		public ActionResult Details(int id)
		{
			return View();
		}

		// GET: Room/Create
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Create(int id)
		{
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			//add building id and map cords to Viewbag
			ViewBag.buildingId = id;
			ViewBag.map = room.GetMapFromBuilding(id);

			return View();
		}

		// POST: Room/Create
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult CreateForm(IFormCollection collection)
		{
			int id = int.Parse(collection["buildingId"]);

			// check if there are files
			if (collection.Files == null)
			{
				TempData["error"] = "Geen bestanden";
				return RedirectToAction("Create", "Room", new { id });
			}

			//check if values of form are correct  and create room
			try
			{
				if (string.IsNullOrEmpty(collection["roomNumber"]) || string.IsNullOrEmpty(collection["coordinates"]) || string.IsNullOrEmpty(collection["name"]) || collection.Files["image"] == null)
				{
					TempData["error"] = "Niet alle velden zijn ingevuld";
					return RedirectToAction("Create", "Room", new { id });
				}

				if (!IsAllowedMimeType(collection.Files["image"]))
				{
					TempData["error"] = "Dit bestandsformaat is niet toegestaan";
					return RedirectToAction("Create", "Room", new { id });
				}

				if (!room.CreateRoom(id, collection["roomNumber"], collection["coordinates"], collection["name"], collection.Files["image"]))
				{
					TempData["error"] = "Er is iets mis gegaan bij het aanmaken van de kamer";
					return RedirectToAction("Create", "Room", new { id });
				}

				TempData["success"] = "De ruimte is succesvol aangemaakt";

				return RedirectToAction("Create", "Room", new { id });
			}
			catch (Exception e)
			{
				TempData["error"] = "Onbekende fout opgetreden";
				return RedirectToAction("Create", "Room", new { id });
			}
		}
        
		// GET: Room/Edit/1/K64
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Edit(int buildingId, string roomNum)
		{
			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

			//add room data to Viewbag
			ViewBag.roomInfo = room.GetAllRoomData(buildingId, roomNum);

			ViewBag.buildingId = buildingId;
			ViewBag.roomNum = roomNum;
			ViewBag.map = room.GetMapFromBuilding(buildingId);

			return View();
		}

		// GET: Room/CoordinateInstructions/1
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult CoordinateInstructions(int buildingId)
		{
			//cordinate instructions
			ViewBag.buildingId = buildingId;
			return View();
		}

		// POST: Room/Edit/5
		[HttpPost]
		[ValidateAntiForgeryToken]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Edit(IFormCollection collection)
		{
			int buildingId = int.Parse(collection["buildingId"]);
			string roomNumber = collection["roomNumber"];
			//try to edit a room and check filled data 
			try
			{
				if (string.IsNullOrEmpty(collection["coordinates"]) || string.IsNullOrEmpty(collection["name"]))
				{
					TempData["error"] = "Niet alle velden zijn ingevuld";
					return RedirectToAction("Edit", "Room", new { buildingId = buildingId, roomNum = roomNumber });
				}

				if (collection.Files != null && collection.Files.Count > 0)
				{
					if (collection.Files["image"] != null)
					{
						if (!IsAllowedMimeType(collection.Files["image"]))
						{
							TempData["error"] = "De gebouw afbeelding is niet het goede type, probeer een .PNG, .JPG of een .GIF";
							return RedirectToAction("Edit", "Room", new { buildingId = buildingId, roomNum = roomNumber });
						}
					}
				}

				//Update the room with validated data
				room.UpdateRoom(buildingId, roomNumber, collection);
				TempData["success"] = "De ruimte is succesvol bijgewerkt";

				return RedirectToAction("Edit", "Room", new { buildingId = buildingId, roomNum = roomNumber });

			}
			catch (Exception e)
			{
				TempData["error"] = "Onbekende fout opgetreden";
				return RedirectToAction("Edit", "Room", new { buildingId = buildingId, roomNum = roomNumber });
			}
		}

		// GET: Room/Delete/5
		[Route("Room/Delete/{buildingId}/{roomNumber}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Delete(int buildingId, string roomNumber)
		{
			// Try to delete a room
			try
			{
				if (!room.checkIfRoomHasSensors(roomNumber))
				{
					TempData["error"] = "Sensoren die gekoppeld zijn aan ruimte: " + roomNumber + " moeten eerst verwijderd worden, voordat de ruimte verwijderd kan worden";
					return RedirectToAction("Overview", "Room", new { id = buildingId });
				}
				else
				{
					//Remove the room
					room.RemoveRoom(roomNumber);
					TempData["success"] = "Ruimte is succesvol verwijderd";
					return RedirectToAction("Overview", "Room", new { id = buildingId });
				}
				
			}
			catch (Exception ex)
			{
				//Error logging
				_logger.LogError("Er is een onbekende fout opgetreden: " + ex.Message);
				TempData["error"] = "Sensoren die gekoppeld zijn aan ruimte: " + roomNumber + " moeten eerst verwijderd worden, voordat de ruimte verwijderd kan worden";
				return RedirectToAction("Overview", "Room", new { id = buildingId });
			}
	
		}

		//method to check file typess
		public bool IsAllowedMimeType(IFormFile file)
		{
			//Accepted mimetypes and extentions
			string[] allowedMimeTypes = { "image/png", "image/jpeg", "image/gif" };
			string[] allowedExtentions = { ".jpg", ".jpeg", ".png", ".gif" };

			if (file != null)
			{
				foreach (var mimeType in allowedMimeTypes)
				{
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

			return false;
		}
	}
}
