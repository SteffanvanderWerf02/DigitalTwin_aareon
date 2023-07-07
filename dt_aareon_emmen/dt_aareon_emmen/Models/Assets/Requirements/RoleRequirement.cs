using Microsoft.AspNetCore.Authorization;

namespace dt_aareon_emmen.Models.Assets.Requirements
{
    public class RoleRequirement : IAuthorizationRequirement
    {
        public RoleRequirement(int roleId)
        {
            RoleId = roleId;
        }

        public int RoleId { get; set; }
    }
}
