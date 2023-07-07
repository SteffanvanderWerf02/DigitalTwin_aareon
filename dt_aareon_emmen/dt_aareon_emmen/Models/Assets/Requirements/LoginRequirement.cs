using Microsoft.AspNetCore.Authorization;

namespace dt_aareon_emmen.Models.Assets.Requirements
{
    public class LoginRequirement : IAuthorizationRequirement
    {
            public LoginRequirement(string mail)
            {
                Mail = mail;
            }

            public string Mail{ get; set; }
    }
}
