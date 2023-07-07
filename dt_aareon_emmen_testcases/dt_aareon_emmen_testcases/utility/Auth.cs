using dt_aareon_emmen_testcases.utility.database;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace dt_aareon_emmen_testcases.utility
{
    public class Auth
    {
        /**
         * 
         * Automate a full login to the webapp (username & pass login + 2fa). 
         * returns the Cookie that is needed to access other pages on the application
         * 
         */
        public static String getSessionTokens(IConfigurationRoot config, Database db)
        {
            // part 1 : [GET] send GET request to / endpoint, retrieve antiforgery token & cookie from login page
            HttpWebResponse getResponse = RequestUtils.SendHttpGetRequest($"{config["WebApp:Protocol"] + config["WebApp:Server"]}:{config["WebApp:Port"]}/", null);
            String forgeryToken = RequestUtils.ExtractAntiForgeryToken(getResponse, "__RequestVerificationToken");
            String forgeryCookie = RequestUtils.ExtractSetCookies(getResponse);

            // part 2 : [POST] send POST request to /login endpoint, retrieve aspnet session token
            String postDataLogin = $"mail={config["WebApp:Username"]}&password={config["WebApp:Password"]}&submit=LOGIN&__RequestVerificationToken={forgeryToken}";
            HttpWebResponse postResponse = RequestUtils.SendHttpPostRequest(
                $"{config["WebApp:Protocol"] + config["WebApp:Server"]}:{config["WebApp:Port"]}/login",
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
            HttpWebResponse getMfaResponse = RequestUtils.SendHttpGetRequest($"{config["WebApp:Protocol"] + config["WebApp:Server"]}:{config["WebApp:Port"]}/Login/mfa", new Dictionary<string, string>() {
                { "Cookie",  sessionForgeryCookiesV1 } // session cookie now has basic authentication details
            });

            // part 4 : [POST] authenticate on /Login/MfaCheck endpoint
            String postData2fa = $"mfa-input={getMfaToken(db, config["WebApp:Username"])}&submit=LOGIN&__RequestVerificationToken={forgeryToken}"; // if 2fa is enabled again

            HttpWebResponse post2faResponse = RequestUtils.SendHttpPostRequest(
                            $"{config["WebApp:Protocol"] + config["WebApp:Server"]}:{config["WebApp:Port"]}/login/MfaCheck",
                            postData2fa,
                            new Dictionary<string, string>() {
                                            { "Cookie", sessionForgeryCookiesV1 },
                                            { "Content-Type", "application/x-www-form-urlencoded" }
                            },
                            true
                        );

            return sessionForgeryCookiesV1;
        }

        /** 
         * 
         * Retrieve the MFA auth token from the database for a specific user (unique mail)
         * 
         */
        public static String getMfaToken(Database db, String username)
        {
            List<Dictionary<String, String>> mfaToken = db.SelectQuery($@"SELECT mfa_token 
                                                                               FROM dt_emmen.user 
                                                                               WHERE LOWER(mail) = LOWER('{username}')",
                                                                               new List<String> { "mfa_token" });

            return mfaToken[0]["mfa_token"] == null ? null : mfaToken[0]["mfa_token"];
        }
    }
}
