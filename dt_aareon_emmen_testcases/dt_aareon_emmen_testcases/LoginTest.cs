using dt_aareon_emmen_testcases.utility;
using dt_aareon_emmen_testcases.utility.database;
using Microsoft.Extensions.Configuration;
using NUnit.Framework.Internal;
using System.Net;

namespace dt_aareon_emmen_testcases


{
    public class LoginTest
    {
        private string host;
        private string username;
        private string password;
        private int port;
        private Database db;

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
        }

        // test 1
        [Test(Description = "[GET] Retrieve the login page, if status code = OK, test succeeded")]
        public void getLoginPage()
        {
            bool success = false;

            try
            {
                HttpWebResponse response = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}/", null);

                if (response.StatusCode == HttpStatusCode.OK)
                {
                    success = true;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");
            }

            Message.consoleMessage(
                @"[*][SUCCESS] Retrieved login page!",
                @"[*][FAIL] Unable to retrieve login page! - testcase : getLoginPage()",
                success
            );
            Assert.IsTrue(success);
        }

        // test 2
        [Test(Description = "[POST] login to the application. First extract the anti forgery token from the webapp, extract the Set-Cookie header, and login")]
        public void loginSuccess()
        {
            HttpWebResponse response = authenticateMvcApp(true);
            bool success = false;
            foreach (string headerKey in response.Headers.AllKeys)
            {
                string headerValue = response.Headers[headerKey].Split("=")[0];

                if (headerKey.Equals("Set-Cookie", StringComparison.OrdinalIgnoreCase))
                {
                    if (headerValue.Equals(".AspNetCore.Session", StringComparison.OrdinalIgnoreCase))
                    {
                        success = true;
                        break;
                    }
                }
            }
            Message.consoleMessage(
                @"[*][SUCCESS] .AspNetCore.Session session was found!",
                @"[*][FAIL] Unable to find .AspNetCore.session! - testcase : loginSuccess()",
                success
            );
            Assert.IsTrue(success);
        }

        // test 3
        [Test(Description = "[POST] login to the application. First extract the anti forgery token from the webapp, extract the Set-Cookie header, and login")]
        public void loginFail()
        {
            HttpWebResponse response = authenticateMvcApp(false);
            bool success = false;

            foreach (string headerKey in response.Headers.AllKeys)
            {
                string headerValue = response.Headers[headerKey].Split("=")[0];

                if (headerKey.Equals("Set-Cookie", StringComparison.OrdinalIgnoreCase))
                {
                    if (headerValue.Equals(".AspNetCore.Session", StringComparison.OrdinalIgnoreCase))
                    {
                        success = true;
                        break;
                    }
                }
            }

            Message.consoleMessage(
                @"[*][SUCCESS] Could not connect with invalid credentials!",
                @"[*][FAIL] Connected with invalid credentials! - testcase : loginFail()", 
                !success
            );

            Assert.IsFalse(success);
        }



        // test 4
        [Test(Description = "[POST] login to the application MFA page")]
        public void loginMfaSuccess()
        {
            HttpWebResponse response = authenticateMvcApp2fa(true);
            String html = RequestUtils.ExtractWebRequestBody(response);
            bool success = false;

            if (RequestUtils.htmlWordCheck(html, new String[] { "Gebouwen overzicht" }))
            {
                success = true;
            }

            Message.consoleMessage(
                @"[*][SUCCESS] Landed on startpage!",
                @"[*][FAIL] Unable to land on stagepage! - testcase : loginMfaSuccess()",
                success
            );

            Assert.IsTrue(success);
        }

        // test 5
        [Test(Description = "[POST] login to the application MFA page")]
        public void loginMfaFail()
        {
            HttpWebResponse response = authenticateMvcApp2fa(false);
            String html = RequestUtils.ExtractWebRequestBody(response);
            bool success = false;

            if (RequestUtils.htmlWordCheck(html, new String[] { "gebouw-overzicht", "gebouwen"}))
            {
                success = true;
            }

            Message.consoleMessage(
                @"[*][SUCCESS] Unable to land on startpage with an invalid token!",
                @"[*][FAIL] Landen on startpage with an invalid token! - testcase : loginMfaFail()",
                !success
            );

            Assert.IsFalse(success);
        }

        // ####################################################################### //
        // ######################## start private methods ######################## //
        // ####################################################################### // 
        private HttpWebResponse authenticateMvcApp(bool validUser)
        {
            this.username = validUser ? this.username : "fakeUser@student.nhlstenden.com";

            // part 1 : send GET request to / endpoint, retrieve antiforgery token & cookie
            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}/", null);
            String forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            String forgeryCookie = RequestUtils.ExtractSetCookies(getResponse);

            // part 2 : send POST request to /login endpoint, retrieve aspnet session token
            String postData = $"mail={this.username}&password={this.password}&submit=LOGIN&__RequestVerificationToken={forgeryToken}";
            HttpWebResponse response = RequestUtils.SendHttpPostRequest(
                $"{this.host}:{this.port}/login",
                postData,
                new Dictionary<string, string>() {
                    { "Cookie", forgeryCookie },
                    { "Content-Type", "application/x-www-form-urlencoded" }
                },
                false
            );

            return response;
        }

        private HttpWebResponse authenticateMvcApp2fa(bool validToken)
        {
            // part 1 : [GET] send GET request to / endpoint, retrieve antiforgery token & cookie from login page
            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}/", null);
            String forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            String forgeryCookie = RequestUtils.ExtractSetCookies(getResponse);

            // part 2 : [POST] send POST request to /login endpoint, retrieve aspnet session token
            String postDataLogin = $"mail={this.username}&password={this.password}&submit=LOGIN&__RequestVerificationToken={forgeryToken}";
            HttpWebResponse postResponse = RequestUtils.SendHttpPostRequest(
                $"{this.host}:{this.port}/login",
                postDataLogin,
                new Dictionary<string, string>() {
                    { "Cookie", forgeryCookie },
                    { "Content-Type", "application/x-www-form-urlencoded" }
                },
                false
            );
            String sessionCookieV1 = $"{RequestUtils.ExtractSetCookies(postResponse)}";
            String sessionForgeryCookiesV1 = $"{forgeryCookie};{sessionCookieV1}";

            // part 3 : [GET] send GET request to /login/mfa endpoint, retrieve updated anti forgery token from form
            HttpWebResponse getMfaResponse = RequestUtils.SendHttpGetRequest($"{this.host}:{this.port}/Login/mfa", new Dictionary<string, string>() { 
                { "Cookie",  sessionForgeryCookiesV1 } // session cookie now has basic authentication details
            });

            // part 4 : [POST] authenticate on /Login/MfaCheck endpoint
            String mfaToken = validToken ? Auth.getMfaToken(this.db, this.username) : "FAKE-TOKEN-TEST";
            String postData2fa = $"mfa-input={mfaToken}&submit=LOGIN&__RequestVerificationToken={forgeryToken}"; // if 2fa is enabled again

            HttpWebResponse post2faResponse = RequestUtils.SendHttpPostRequest(
                            $"{this.host}:{this.port}/login/MfaCheck",
                            postData2fa,
                            new Dictionary<string, string>() {
                                            { "Cookie", sessionForgeryCookiesV1 },
                                            { "Content-Type", "application/x-www-form-urlencoded" }
                            },
                            true
                        );
            return post2faResponse;
        }
    }
}