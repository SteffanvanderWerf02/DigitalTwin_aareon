using dt_aareon_emmen.Models.Assets.Requirements;
using Microsoft.AspNetCore.Authorization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace dt_aareon_emmen.Models.Assets.NewFolder
{
    public class RoleHandler : AuthorizationHandler<RoleRequirement>
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        public RoleHandler(IHttpContextAccessor httpContextAccessor)
        {
            this._httpContextAccessor = httpContextAccessor;
        }
        //Task that handles the roles of a user
        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, RoleRequirement requirement)
        {
            try
            {
                string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");
                JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
                int roleId = int.Parse(jwt.Claims.First(claim => claim.Type == ClaimTypes.Role).Value);

                if (requirement.RoleId == roleId)
                {
                    context.Succeed(requirement);
                }
                return Task.CompletedTask;
            }
            catch (Exception ex)
            {
                return Task.CompletedTask;
            }
        }
    }
}
