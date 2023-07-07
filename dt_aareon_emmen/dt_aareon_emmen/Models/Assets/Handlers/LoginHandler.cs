namespace dt_aareon_emmen.Models.Assets.Handlers
{
    using global::dt_aareon_emmen.Models.Assets.Requirements;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;
    using System.IdentityModel.Tokens.Jwt;
    using System.Security.Claims;

    namespace dt_aareon_emmen.Models.Assets.Handlers
    {
        public class LoginHandler : AuthorizationHandler<LoginRequirement>
        {
            private readonly IHttpContextAccessor _httpContextAccessor;

            public LoginHandler(IHttpContextAccessor httpContextAccessor)
            {
                _httpContextAccessor = httpContextAccessor;
            }

            //Task that handles the checks if user is allowed to be there.
            protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, LoginRequirement requirement)
            {
                try
                {
                    string sessionToken = _httpContextAccessor.HttpContext.Session.GetString("Token");
                    JwtSecurityToken jwt = new JwtSecurityTokenHandler().ReadJwtToken(sessionToken);

                    string mail = jwt.Claims.First(claim => claim.Type == ClaimTypes.Authentication).Value;
                    
                    if (!string.IsNullOrEmpty(mail))
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
}
