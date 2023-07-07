using dt_aareon_emmen_testcases.utility.database;
using dt_aareon_emmen_testcases.utility;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net;

namespace dt_aareon_emmen_testcases
{
    public class UserTest
    {
        private string host;
        private string username;
        private string password;
        private int port;
        private Database db;
        private string sessionForgeryCookie;

        [SetUp]
        public void setup()
        {
            IConfigurationRoot config = new ConfigurationBuilder()
                .AddJsonFile("config.json")
                .Build();

            // base url of webapp
            this.host = config["WebApp:Protocol"] + config["WebApp:Server"];

            // username & password of admin user
            this.username = config["WebApp:Username"];
            this.password = config["WebApp:Password"];

            // used port 
            this.port = int.Parse(config["WebApp:Port"]);


            // database connection
            this.db = new Database(
                                    config["Database:Username"],
                                    config["Database:Host"],
                                    config["Database:Password"],
                                    config["Database:DatabaseName"],
                                    config["Database:Port"]
            );

            // get the session forgery cookie so that you can access any other url
            this.sessionForgeryCookie = Auth.getSessionTokens(config, this.db);
        }

        // test 1
        [Test]
        public void getUserCreate()
        {
            String path = "/User/Create";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebruiker toevoegen" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'user create' page!",
                @"[*][FAIL] Unable to retrieve 'user create' page! - testcase : getUserCreate()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 2
        [Test]
        public void getUserEdit()
        {
            String path = "/User/Edit/arie.vanderdeijl@aareon.nl";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebruiker bewerken" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'user edit' page!",
                @"[*][FAIL] Unable to retrieve 'user edit' page! - testcase : getUserEdit()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 3
        [Test]
        public void getUserIndex()
        {
            String path = "/User/Index";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebruikers overzicht" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'user index' page!",
                @"[*][FAIL] Unable to retrieve 'user index' page! - testcase : getUserIndex()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 4
        [Test]
        public void getUserPassword()
        {
            String path = "/User/Password";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Wachtwoord wijzigen" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'change password' page!",
                @"[*][FAIL] Unable to retrieve 'change password' page! - testcase : getUserPassword()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 5
        [Test]
        public void getUserProfile()
        {
            String path = "/User/Profile";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Profiel" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'user profile' page!",
                @"[*][FAIL] Unable to retrieve 'user profile' page! - testcase : getUserProfile()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 6
        [Test]
        public void getUserSettings()
        {
            String path = "/User/Settings";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Instellingen" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'user settings' page!",
                @"[*][FAIL] Unable to retrieve 'user settings' page! - testcase : getUserSettings()",
                match
            );

            Assert.IsTrue(match);
        }

        [Test]
        public void changePassword()
        {
            string getPath = "/User/Password";
            string postPath = "/User/ChangePassword";
            string curPassword = "betoeterd12$!";
            string curPasswordHash = "89fb2117ff321068f31f9cc84f8631e5a084634db39207613f960a41dde704ff";
            string newPassword = "Test123!";
            string newPasswordHash = "54de7f606f2523cba8efac173fab42fb7f59d56ceff974c8fdb7342cf2cfe345";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{getPath}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            string forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            string postData = $"current-password={curPassword}&new-pw={newPassword}&new-pw-repeat={newPassword}&__RequestVerificationToken={forgeryToken}";
            
            RequestUtils.SendHttpPostRequest($"{this.host}:{this.port}{postPath}", postData, new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie },
                { "Content-Type", "application/x-www-form-urlencoded" }
            },
            true
            );

            List<Dictionary<string, string>> result = this.db.SelectQuery(@$"
                                                                            SELECT password
                                                                            FROM dt_emmen.user
                                                                            WHERE mail = '{this.username}'",
                                                                            new List<string> { "password" });

			bool updatePasswordToOriginal = this.db.ExecuteQuery(@"UPDATE dt_emmen.user 
                            SET password = @password 
                            WHERE mail = @mail",
							new Dictionary<String, String>()
							{
								["password"] = curPasswordHash,
								["mail"] = this.username
							});

            if (!updatePasswordToOriginal)
            {
                Console.WriteLine("[*][FAIL] Could not update user account! - testcase : changePassword()");
                Assert.IsTrue(false);
            }

			bool match = result[0]["password"].Equals(newPasswordHash, StringComparison.OrdinalIgnoreCase);

            Message.consoleMessage(
                @"[*][SUCCESS] Updated 'password' page!",
				@"[*][FAIL] Failed to update 'password' page! - testcase : changePassword()",
                match
            );

            Assert.IsTrue(match);
        }


        [Test]
        public void changeProfileName()
        {
            String getPath = "/User/Profile";
            String postPath = "/User/ChangeProfile";
            String newUsername = "test_user";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{getPath}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            String forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            String postData = $"username={newUsername}&__RequestVerificationToken={forgeryToken}";

            RequestUtils.SendHttpPostRequest($"{this.host}:{this.port}{postPath}", postData, new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie },
                { "Content-Type", "application/x-www-form-urlencoded"}
            },
            true
            );

            List<Dictionary<String, String>> result = this.db.SelectQuery(@$"
                                                                            SELECT username 
                                                                            FROM dt_emmen.user 
                                                                            WHERE mail = '{this.username}'",
                                                                            new List<string> { "username" });

            bool match = result[0]["username"].Equals(newUsername, StringComparison.OrdinalIgnoreCase);

            Message.consoleMessage(
                @"[*][SUCCESS] Updated 'user profile' page!",
                @"[*][SUCCESS] failed to update 'user profile' page!",
                match
            );

            Assert.IsTrue(match);
        }
    }
}
