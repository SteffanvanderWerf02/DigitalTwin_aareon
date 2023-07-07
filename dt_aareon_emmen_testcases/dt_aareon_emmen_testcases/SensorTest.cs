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
    public class SensorTest
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

    //    // test 1
    //    [Test]
    //    public void getSensorCreate()
    //    {
    //        String path = "/Sensor/Create";

    //        HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
    //        {
    //            { "Cookie", this.sessionForgeryCookie }
    //        });

    //        bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Sensor toevoegen" });

    //        Message.consoleMessage(
    //            @"[*][SUCCESS] Retrieved 'sensor create' page!",
				//@"[*][FAIL] Unable to retrieve 'sensor create' page! - testcase : getSensorCreate()",
    //            match
    //        );

    //        Assert.IsTrue(match);
    //    }

        // test 2
        [Test]
        public void getSensorIndex()
        {
            String path = "/Sensor/Index/1";

            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}{path}", new Dictionary<string, string>()
            {
                { "Cookie", this.sessionForgeryCookie }
            });

            bool match = RequestUtils.htmlWordCheck(RequestUtils.ExtractWebRequestBody(getResponse), new string[] { "Sensor overzicht" });

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved 'sensor index' page!",
				@"[*][FAIL] Unable to retrieve 'sensor index' page! - testcase : getSensorIndex()",
                match
            );

            Assert.IsTrue(match);
        }
    }
}
