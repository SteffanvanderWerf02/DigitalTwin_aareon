using dt_aareon_emmen.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace dt_aareon_emmen.Controllers
{
	public class Facilitor : Controller
	{
        private readonly IHttpContextAccessor _httpContextAccessor;

        private FacilitorM facilitorM;

        private readonly ILogger<Facilitor> _logger;
        public Facilitor(ILogger<Facilitor> _logger, ILogger<Sensor> S_logger, ILogger<Building> B_logger, IConfiguration _configuration, IHttpContextAccessor _httpContextAccessor)
        {
            this._logger = _logger;
			this._httpContextAccessor = _httpContextAccessor;
            this.facilitorM = new FacilitorM(_configuration);
        }

        // GET: /Facilitor/index/(buildingId)
		[Route("Facilitor/Index/{id:int}")]
        [HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Index(int id)
		{
			string token = _httpContextAccessor.HttpContext.Session.GetString("Token");
			JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

			ViewBag.role = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);
			ViewBag.sensors = facilitorM.GetSensors(id);
			ViewBag.sensorsWithFacilitorKey = facilitorM.GetSensorsWithFacilitorKey();
            ViewBag.dataTypes = facilitorM.GetDataTypesFacilitor();
			ViewBag.buildingId = id;

			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}
			
			return View("Index");
		}

		// GET: /Facilitor/create/(buildingId)
		[Route("Facilitor/Create/{id:int}")]
        [HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Create(int id)
		{
			ViewBag.sensors = facilitorM.GetSensors(id);
            ViewBag.dataTypes = facilitorM.GetDataTypesFacilitor();
			ViewBag.buildingId = id;

			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}
				
			return View("Create");
		}

		// POST: /Facilitor/Create/(buildingId)
		[Route("Facilitor/Create/{id:int}")]
        [HttpPost]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public IActionResult Create(IFormCollection collection, int id)
		{

			if (string.IsNullOrEmpty(collection["sensors"]) || string.IsNullOrEmpty(collection["facilitorKey"]) || string.IsNullOrEmpty(collection["dataTypeId"]))
			{
				TempData["error"] = "Niet alle velden zijn ingevuld";
				return RedirectToAction("Create", new { id = id });
			}

			try
			{
				facilitorM.AddFacilitorKeyToSensor(collection["sensors"], int.Parse(collection["facilitorKey"]), int.Parse(collection["dataTypeId"]));

				TempData["success"] = "Facilitor key is succesvol toegevoegd";
				return RedirectToAction("Create", new { id = id });
			}
			catch (Exception e)
			{
				TempData["error"] = "Facilitor ID bestaat al, probeer het opnieuw";
				return RedirectToAction("Create", new { id = id });
			}
		}

		//GET: /Facilitor/edit/(sensorid)/(buildingId)
		[Route("Facilitor/Edit/{facilitor_id:int}/{id:int}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Edit(int facilitor_id, int id)
		{
			ViewBag.allSensors = facilitorM.GetSensors(id);
			ViewBag.sensorFacilitorId = facilitorM.GetSensorId(facilitor_id);
			ViewBag.dataTypes = facilitorM.GetDataTypesFacilitor();
			ViewBag.dataType = facilitorM.GetDataType(facilitor_id);
			ViewBag.dataTypeName = facilitorM.GetDataTypeName(facilitor_id);

			ViewBag.buildingId = id;
			ViewBag.facilitorId = facilitor_id;

			if (TempData["error"] != null)
			{
				ViewBag.error = TempData["error"].ToString();
			}

           return View("Edit");		
		}

		//POST: Facilitor/edit/(facilitor_id)/(buildingId)
		[Route("Facilitor/Edit/{facilitor_id:int}/{id:int}")]
		[HttpPost]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public ActionResult Edit(IFormCollection collection, int facilitor_id, int id)
		{
			try
			{
				//checks if input fields are empty
				if (string.IsNullOrEmpty(collection["sensors"]) || string.IsNullOrEmpty(collection["facilitorKey"]) || string.IsNullOrEmpty(collection["datatypes"]))
				{
					//error message
					TempData["error"] = collection["sensors"] + collection["facilitorKey"] + collection["datatypes"];
					return RedirectToAction("Edit", "Facilitor", new { id = id });
				}else{
					//updates facilitor data
					facilitorM.EditFacilitorKey(collection["sensors"],facilitor_id, int.Parse(collection["facilitorKey"]), int.Parse(collection["datatypes"]));	
					TempData["success"] = "Facilitor Key is succesvol bijgewerkt";				
					return RedirectToAction("index", "Facilitor", new {id = id});
				}
			}
			catch
			{
				TempData["error"] = "Er is iets fouts gegaan. Of de Facilitor Key bestaat al";
				return RedirectToAction("Edit", "Facilitor", new { id = id });
			}
		}

		//Deletes a sensor-faciltor relation
		[Route("Facilitor/Delete/{id:int}/{facilitor_id:int}")]
		[HttpGet]
		[Authorize(Policy = "Admin")]
		[Authorize(Policy = "mfa")]
		public IActionResult Delete(int id, int facilitor_id)
		{
			try
			{
				//verwijdert de sensor facilitor relatie
				facilitorM.RemoveFacilitorKey(facilitor_id);
				TempData["success"] = "Facilitor Key is succesvol verwijdert";
				return RedirectToAction("Index", "Facilitor", new { id = id });

			}
			catch (Exception ex)
			{
				TempData["error"] = "Er is iets mis gegaan, probeer het opnieuw";
				return RedirectToAction("Index", "Facilitor", new { id = id });
			}
		}
    }
}
