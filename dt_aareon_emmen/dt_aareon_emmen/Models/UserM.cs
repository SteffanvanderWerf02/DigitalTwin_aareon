using crypto;
using dt_aareon_emmen.Controllers;
using Microsoft.AspNetCore.Identity;
using Microsoft.CodeAnalysis.Diagnostics;
using Microsoft.Extensions.Logging;
using MySqlX.XDevAPI.Common;
using System.Collections.Generic;
using System.Net.Mail;

namespace dt_aareon_emmen.Models
{
	public class UserM : IdentityUser
	{
		public string Email { get; set; }
		public string Username { get; set; }
		public string Role { get; set; }
		private Database db;
		private ILogger<User> _logger;
		private IConfiguration _configuration;

		public UserM(ILogger<User> _logger, IConfiguration _configuration)
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

		public List<Dictionary<string, string>> GetCurrentUserPassword(string mail)
		{

			List<Dictionary<string, string>> result = db.SelectQueryPs("SELECT password FROM dt_emmen.user WHERE mail = @mail",
																		new List<string> { "password" },
																		new Dictionary<string, string>()
																		{
																			["mail"] = mail,
																		});

			if (result == null)
			{
				_logger.LogError($"Could not retrieve password of user {mail}");
			}
			return result;
		}

		/** updatePassword()
         * 
         * update the password of an user, 
         * 
         */
		public Boolean UpdatePassword(string mail, string newPwHashed)
		{

			Boolean result = db.ExecuteQuery(@"
                                             UPDATE dt_emmen.user 
                                             SET password = @password 
                                             WHERE mail = @mail",
											 new Dictionary<string, string>()
											 {
												 ["password"] = newPwHashed,
												 ["mail"] = mail
											 });

			if (!result)
			{
				_logger.LogError($"Could not update password of user {mail}!");
			}
			return result;
		}

		public List<Dictionary<string, string>> GetProfile(string mail)
		{

			List<Dictionary<string, string>> result = db.SelectQueryPs(@"
                                                                       SELECT mail, username 
                                                                       FROM dt_emmen.user 
                                                                       WHERE mail = @mail",
																	  new List<string> { "mail", "username" },
																	  new Dictionary<string, string>()
																	  {
																		  ["mail"] = mail,
																	  });

			return result;
		}

		/** updateProfile()
	   *
	   * update the profile of a user, changes the name 
	   */
		public Boolean ChangeProfile(string name, string mail)
		{

			Boolean result = db.ExecuteQuery(@"
                                             UPDATE dt_emmen.user 
                                             SET username = @name 
                                             WHERE mail = @mail",
											 new Dictionary<string, string>()
											 {
												 ["name"] = name,
												 ["mail"] = mail
											 });

			if (!result)
			{
				_logger.LogError($"Could not update name of user {mail}!");
			}
			return result;
		}

		public string userName { get; set; }
		public List<Dictionary<string, string>> GetUsers()
		{

			List<Dictionary<string, string>> data = this.db.SelectQuery(@"
                                                                        SELECT username, mail, role.name 
                                                                        FROM dt_emmen.user 
                                                                        INNER JOIN dt_emmen.role 
                                                                        ON dt_emmen.user.role_id = role.id",
																		new List<string> { "username", "mail", "name" });
			return data;
		}

		// Edits the user info of a user matching the given email in the database.
		public void EditUser(string email, string username, string role)
		{

			this.db.ExecuteQuery(@"
                                 UPDATE dt_emmen.user 
                                 SET username = @username, 
                                 role_id = CAST (@role AS INTEGER) 
                                 WHERE mail = @email",
								 new Dictionary<string, string>()
								 {
									 ["username"] = username,
									 ["role"] = role,
									 ["email"] = email,
								 });

		}

		// Deletes a user that matches the given email from the database.
		public void DeleteUser(string email)
		{

			try
			{
				this.db.ExecuteQuery(@"
                                     DELETE FROM dt_emmen.user 
                                     WHERE mail = @email",
									 new Dictionary<string, string>()
									 {
										 ["email"] = email,
									 });
			}
			catch (Exception)
			{
				throw;
			}
		}

		// Function that gets all the roles from the database
		public List<Dictionary<string, string>> GetRoles()
		{

			List<Dictionary<string, string>> data = this.db.SelectQuery(@"
                                                                        SELECT id, name 
                                                                        FROM dt_emmen.role",
																		new List<string> { "id", "name" });
			return data;
		}

		// Function that returns user data if a user matching the given email address exists.
		public List<Dictionary<string, string>> GetUser(string email)
		{

			List<Dictionary<string, string>> data = this.db.SelectQueryPs(@"
                                                                          SELECT username, mail, role.name 
                                                                          FROM dt_emmen.user 
                                                                          INNER JOIN dt_emmen.role 
                                                                          ON dt_emmen.user.role_id = dt_emmen.role.id 
                                                                          WHERE mail = @email",
																		  new List<string> { "username", "mail", "name" },
																		  new Dictionary<string, string>()
																		  {
																			  ["email"] = email,
																		  });
			return data;
		}

		// Funtion that return true of a role exists that matches the given role id.
		public Boolean RoleExists(string role_id)
		{

			List<Dictionary<string, string>> data = this.db.SelectQueryPs(@"
                                                                          SELECT id, name FROM 
                                                                          dt_emmen.role 
                                                                          WHERE id = CAST (@id AS INTEGER)",
																		  new List<string> { "id", "name" },
																		  new Dictionary<string, string>()
																		  {
																			  ["id"] = role_id,
																		  });
			if (data != null)
			{
				if (data.Count > 0)
				{
					return true;
				}
			}
			return false;
		}

		// Adds a user to the database.
		public void CreateUser(string name, string email, string role_id, string password)
		{

			this.db.ExecuteQuery(@"
                                 INSERT INTO dt_emmen.user (mail, role_id, password, username) 
                                 VALUES (@mail, CAST (@role_id AS INTEGER), @password, @username)",
								 new Dictionary<string, string>()
								 {
									 ["mail"] = email.ToLower(),
									 ["role_id"] = role_id,
									 ["password"] = password,
									 ["username"] = name,
								 });
		}

		public Boolean IsValidEmail(string email)
		{
			bool isValid = true;
			try
			{
				MailAddress emailAdress = new MailAddress(email);
			}
			catch
			{
				isValid = false;
			}
			return isValid;
		}
	}
}
