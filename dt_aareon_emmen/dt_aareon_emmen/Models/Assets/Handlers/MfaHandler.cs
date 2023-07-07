using dt_aareon_emmen.Models.Assets.Requirements;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace dt_aareon_emmen.Models.Assets.Handlers
{
    public class MfaHandler : AuthorizationHandler<MfaRequirement>
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public MfaHandler(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        //Handles task that checkis if mfa is set
        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, MfaRequirement requirement)
        {
            try
            {
                string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("MfaToken");
                
                if (string.IsNullOrEmpty(sessionToken))
                {   
                    if (requirement.Mfa == false)
                    {
                        context.Succeed(requirement);
                    }
                    return Task.CompletedTask;
                }

                JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);
                string value = jwt.Claims.First(claim => claim.Type == ClaimTypes.Authentication).Value;
                bool mfaAuth = Boolean.Parse(value);

                if (string.IsNullOrEmpty(jwt.Claims.First(claim => claim.Type == ClaimTypes.Authentication).Value))
                {
                  return Task.CompletedTask;
                }

                if (requirement.Mfa == mfaAuth)
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
