using dt_aareon_emmen.Controllers;

namespace dt_aareon_emmen.Models
{
	public class LoginM
	{
		// LOGGER to log on different log levels, configuration which contains everything there is in appsettings.json, used in both constructors
		private ILogger<Login> _logger;
		private IConfiguration _configuration;

		private Database db;

		public LoginM(ILogger<Login> _logger, IConfiguration _configuration)
		{
			this._logger = _logger;
			this._configuration = _configuration;

			this.db = new Database(
								   this._configuration.GetValue<string>("DatabaseDetails:Username"),
								   this._configuration.GetValue<string>("DatabaseDetails:Host"),
								   this._configuration.GetValue<string>("DatabaseDetails:Password"),
								   this._configuration.GetValue<string>("DatabaseDetails:Database"),
								   this._configuration.GetValue<string>("DatabaseDetails:Port")
								   );
		}

		/** getUserRecord()
         * 
         * retrieve a record from the user if it has a record within the database
         * 
         */
		public List<Dictionary<string, string>> GetUserRecord(string mail, string passwordHashed)
		{

			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"
                                                                            SELECT mail, password 
                                                                            FROM dt_emmen.user 
                                                                            WHERE mail = @mail 
                                                                            AND password = @password",
																			new List<string> { "mail", "password" },
																			new Dictionary<string, string>()
																			{
																				["mail"] = mail,
																				["password"] = passwordHashed
																			});

			return result;
		}

		// Get the full details of a User with email and password
		public List<Dictionary<string, string>> GetFullUserRecord(string mail, string passwordHashed)
		{

			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"
                                                                            SELECT mail, username, role_id 
                                                                            FROM dt_emmen.user 
                                                                            WHERE mail = @mail 
                                                                            AND password = @password",
																			new List<string> { "mail", "username", "role_id" },
																			new Dictionary<string, string>()
																			{
																				["mail"] = mail,
																				["password"] = passwordHashed
																			});

			return result;
		}

		//Update the MFA token of a user
		public void SetMultiFactorAuthKey(string email, string token)
		{

			this.db.ExecuteQuery(@"
                                 UPDATE dt_emmen.user
                                 SET mfa_token = @token
                                 WHERE mail = @mail",
								 new Dictionary<string, string>()
								 {
									 ["token"] = token,
									 ["mail"] = email
								 });

		}

		//Gets the MFA token from a user
		public List<Dictionary<string, string>> GetUserMfaToken(string mail)
		{

			List<Dictionary<string, string>> result = this.db.SelectQueryPs(@"
                                                                            SELECT mfa_token 
                                                                            FROM dt_emmen.user 
                                                                            WHERE mail = @mail",
																			new List<string> { "mfa_token" },
																			new Dictionary<string, string>()
																			{
																				["mail"] = mail,
																			});

			return result;
		}
	}
}