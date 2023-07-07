using System.Text.RegularExpressions;

namespace dt_aareon_emmen.Models.Assets
{
    /** Validate
     * 
     * class used for validation related regex
     * 
     */
    public class Validate
    {
        /* ValidatePassword()
         * 
         * Utility method.
         * Checks if the user password conditions are met
         */
        public static ValidatePasswordResult ValidatePassword(string password)
        {
            string input = password;

            if (string.IsNullOrWhiteSpace(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord mag niet leeg zijn");
            }

            Regex hasNumber = new Regex(@"[0-9]+"); // - has atleast one integer
            Regex hasUpperChar = new Regex(@"[A-Z]+"); // - has atleast 1 uppercase character
            Regex hasMiniMaxChars = new Regex(@".{8,15}"); // - has atleast x to x characters in their password
            Regex hasLowerChar = new Regex(@"[a-z]+"); // - has atleast 1 lowercase character
            Regex hasSymbols = new Regex(@"[!@#$%^&*()_+=\[{\]};:<>|./?,-]"); // - has atleast 1 symbolic character in their password

            if (!hasLowerChar.IsMatch(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord bevat geen kleine letters");
            }
            else if (!hasUpperChar.IsMatch(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord moet tenminste een hoofdletter bevatten");
            }
            else if (!hasMiniMaxChars.IsMatch(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord moet tussen de 8 en 15 karakters zijn");
            }
            else if (!hasNumber.IsMatch(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord moet tenminste een numerieke waarde bevatten");
            }
            else if (!hasSymbols.IsMatch(input))
            {
                return new ValidatePasswordResult(false, "Het wachtwoord moet tenminste een speciaal karakter bevatten");
            }
            else
            {
                return new ValidatePasswordResult(true, "succes!");
            }
        }

        public static Boolean IsAlphabetical(string name)
        {
            if (Regex.IsMatch(name, @"^[\p{L}\s]+$"))
            {
                return true;
            }
            return false;
        }
    }

    /** ValidatePasswordResult
     * 
     * contains the result of the ValidatePassword() method within the Validate class
     * 
     */
    public class ValidatePasswordResult
    {
        private bool result;
        private string message;
        public ValidatePasswordResult(bool result, string message)
        {
            this.result = result;
            this.message = message;
        }

        public bool GetResult()
        {
            return this.result;
        }

        public string GetMessage()
        {
            return this.message;
        }
    }
}

