using System;
using System.Text;
using System.Security.Cryptography;

namespace dt_aareon_emmen.Models.Assets
{
    public class Hash
    {
        //Makes the hash of a String in SHA256
        public static string ComputeSHA256(string s)
        {
            string hash = string.Empty;

            // Initialize a SHA256 hash object
            using (SHA256 sha256 = SHA256.Create())
            {
                // Compute the hash of the given string
                byte[] hashValue = sha256.ComputeHash(Encoding.UTF8.GetBytes(s));

                // Convert the byte array to string format
                foreach (byte b in hashValue)
                {
                    hash += $"{b:X2}";
                }
            }
            return hash.ToLower();
        }
    }
}
