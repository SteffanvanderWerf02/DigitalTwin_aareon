using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace dt_aareon_emmen.Models.Assets.Requirements
{
    public class MfaRequirement : IAuthorizationRequirement
    {
        public MfaRequirement(bool mfa)
        {
            Mfa = mfa;
        }

        public bool Mfa { get; set; }
    }
}
