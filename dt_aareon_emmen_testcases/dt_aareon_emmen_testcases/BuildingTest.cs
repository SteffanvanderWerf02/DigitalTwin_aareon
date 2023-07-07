using dt_aareon_emmen_testcases.utility.database;
using dt_aareon_emmen_testcases.utility;
using Microsoft.Extensions.Configuration;
using System.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dt_aareon_emmen_testcases
{
    public class BuildingTest
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
        public void getBuildingIndex()
        {
            String path = "/Building";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebouwen overzicht" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'Gebouwen overzicht' page!",
                @"[*][FAIL] Unable to retrieve 'Gebouwen overzicht' page! - testcase : getBuildingIndex()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 2
        [Test]
        public void getBuildingCreate()
        {
            String path = "/Building/Create";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebouw toevoegen" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'Gebouw toevoegen' page!",
                @"[*][FAIL] Unable to retrieve 'Gebouw toevoegen' page! - testcase : getBuildingCreate()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 3
        [Test]
        public void getBuildingEdit()
        {
            String path = "/Building/Edit/1";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebouw bewerken" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'Gebouw bewerken' page!",
                @"[*][FAIL] Unable to retrieve 'Gebouw bewerken' page! - testcase : getBuildingIndex()",
                match
            );

            Assert.IsTrue(match);
        }

        // test 4
        [Test]
        public void getBuildingMap()
        {
            String path = "/Building/Map/1";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebouw plattegrond", "Gebouw plattegrond" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'Gebouw plattegrond' page!",
                @"[*][FAIL] Unable to retrieve 'Gebouw plattegrond' page! - testcase : getBuildingIndex()",
                match
            );

            Assert.IsTrue(match);
        }

        // // test 5
        // [Test]
        // public void InsertBuilding()
        // {
        // String path = "/Building/Create";
        // String name = "testNaam";
        // String type = "testKantoor";
        // String company = "testCompanyNaam";
        // String forgeryToken = RequestUtils.ExtractAntiForgeryToken(RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
        // {
        //     { "Cookie", this.sessionForgeryCookie }
        // }), "__RequestVerificationToken");

        // RequestUtils.SendHttpPostRequestWithImages(
        //     $"{this.host}:{this.port}{path}",
        //     new Dictionary<string, string>()
        //     {
        //         { "name", name },
        //         { "type", type },
        //         { "company", company},
        //         { "__RequestVerificationToken",  forgeryToken},
        //     },
        //     new Dictionary<string, string>()
        //     {
        //         { "Cookie", this.sessionForgeryCookie},
        //         { "Content-Type", "multipart/form-data; boundary=----WebKitFormBoundaryANKYL5Ar8UWvsUYK" }
        //     },
        //     new Dictionary<string, byte[]>()
        //     {
        //         { "image", File.ReadAllBytes("utility/test-images/test-image-1.jpg")},
        //         { "mapimage", File.ReadAllBytes("utility/test-images/test-image-2.jpg")}
        //     },
        //     true
        // );

        // List<Dictionary<String, String>> data = this.db.SelectQuery(@$"
        //                         SELECT name 
        //                         FROM dt_emmen.building 
        //                         WHERE name = '{name}'
        //                         AND type = '{type}'
        //                         AND company = '{company}'
        //                       ", 
        //                       new List<String>
        //                       {
        //                           "name"
        //                       });

        // bool match = data[0]["name"].Equals(name, StringComparison.OrdinalIgnoreCase);

        // Message.consoleMessage(
        //     @"[*][SUCCESS] Found 'Inserted building' in database!",
        //     @"[*][FAIL] Unable to find 'inserted building' in database page! - testcase : insertBuilding()",
        //     match
        // );

        // Assert.IsTrue(match);
        // }

        // test 6
        [Test]
        public void EditBuilding()
        {
            string getPath = "/Building/Edit/1";
            string postPath = "/Building/Update";
            string newName = "Aareon Vestiging Emmen";
            string newType = "Loods";
            string newCompany = "Aareon BV";
            int newRetention = 30;

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{getPath}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            string forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            string postData = $"name={newName}&type={newType}&company={newCompany}&retention={newRetention}&__RequestVerificationToken={forgeryToken}&id=1";

            HttpWebResponse r = RequestUtils.SendHttpPostRequest($"{this.host}:{this.port}{postPath}", postData, new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie },
                { "Content-Type", "application/x-www-form-urlencoded" }
            },
            true
            );

            List<Dictionary<string, string>> result = this.db.SelectQuery(@$"
                                                                           SELECT name, type, company, retention_period
                                                                           FROM dt_emmen.building
                                                                           WHERE id = 1",
                                                                           new List<string> { "name", "type", "company", "retention_period" });

            bool match = result[0]["name"].Equals(newName, StringComparison.OrdinalIgnoreCase) && result[0]["type"].Equals(newType, StringComparison.OrdinalIgnoreCase) && result[0]["company"].Equals(newCompany, StringComparison.OrdinalIgnoreCase) && int.Parse(result[0]["retention_period"]) == newRetention;

            Message.consoleMessage(
               @"[*][SUCCESS] Updated the 'building create' page!",
               @"[*][FAIL] Failed to update the 'building edit' page!",
               match
            );

            Assert.IsTrue(match);
        }

        // // test 6
        // [Test]
        // public void deleteBuilding()
        // {
        //    String path = "/building";

        //    HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
        //    {
        //        { "Cookie", this.sessionForgeryCookie }
        //    });

        //    bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Gebouwen overzicht" });

        //    Message.consoleMessage(
        //        @"[*][SUCCESS] Retrieved 'Gebouwen overzicht' page!",
        //        @"[*][FAIL] Unable to retrieve 'Gebouwen overzicht' page! - testcase : getBuildingIndex()",
        //        match
        //    );

        //    Assert.IsTrue(match);
        // }
    }
}
