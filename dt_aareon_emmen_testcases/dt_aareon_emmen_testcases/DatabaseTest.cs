using dt_aareon_emmen_testcases.utility.database;
using dt_aareon_emmen_testcases.utility;
using Microsoft.Extensions.Configuration;

namespace dt_aareon_emmen_testcases
{
    public class DatabaseTest
    {
        private Database db;
        private IConfigurationRoot config;

        [SetUp]
        public void setup()
        {
            // init config file
            config = new ConfigurationBuilder()
                .AddJsonFile("config.json")
                .Build();

            // db connection (correct)
            this.db = new Database(
                    this.config["Database:Username"],
                    this.config["Database:Host"],
                    this.config["Database:Password"],
                    this.config["Database:DatabaseName"],
                    this.config["Database:Port"]
            );
        }

        [Test(Description = "Test if a succesfull connection to the database can be made")]
        public void connectionTestSuccess()
        {
            bool success = false;

            List<Dictionary<String, String>> currentUser = this.db.SelectQuery($@"SELECT mail 
                                                                                FROM dt_emmen.user 
                                                                                WHERE LOWER(mail) = LOWER('{config["Database:ConnectionTest:User"]}')",
                                                                                new List<String> { "mail" });

            if (currentUser != null)
            {
                if (currentUser[0]["mail"].Equals(this.config["Database:ConnectionTest:User"], StringComparison.OrdinalIgnoreCase))
                {
                    success = true;
                }
            }

            Message.consoleMessage(
                 @$"[*][SUCCESS] Succesfully found user {this.config["Database:ConnectionTest:User"]}!",
                 @$"[*][FAIL] Unable to find user {this.config["Database:ConnectionTest:User"]}! - testcase : connectionTestSuccess()",
                 success
             );

            Assert.IsTrue(success);
        }


        [Test(Description = "Test if a database connection fails")]
        public void connectionTestFail()
        {
            bool success = false;

            // database connection
            this.db = new Database(
                    "fakeUser",
                    this.config["Database:Host"],
                    this.config["Database:Password"],
                    this.config["Database:DatabaseName"],
                    this.config["Database:Port"]
            );

            List<Dictionary<String, String>> currentUser = this.db.SelectQuery($@"SELECT mail 
                                                                                FROM dt_emmen.user 
                                                                                WHERE LOWER(mail) = LOWER('{this.config["Database:ConnectionTest:User"]}')",
                                                                                new List<String> { "mail" });

            if (currentUser != null)
            {
                if (currentUser[0]["mail"].Equals(this.config["Database:ConnectionTest:User"], StringComparison.OrdinalIgnoreCase))
                {
                    success = true;
                }
            }

            Message.consoleMessage(
                @"[*][SUCCESS] Could not connect with invalid credentials!",
                @"[*][FAIL] Connected with invalid credentials! - testcase : connectionTestFail()",
                !success
            );

            Assert.IsFalse( success );
        }
    }
}
