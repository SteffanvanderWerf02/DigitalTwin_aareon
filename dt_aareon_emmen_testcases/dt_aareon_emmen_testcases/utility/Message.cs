using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dt_aareon_emmen_testcases.utility
{
    public class Message
    {
        public static void consoleMessage(String successMessage, String failMessage, bool success)
        {
            if (success)
            {
                Console.WriteLine(successMessage);
            }
            else
            {
                Console.WriteLine(failMessage);
            }
        }
    }
}
