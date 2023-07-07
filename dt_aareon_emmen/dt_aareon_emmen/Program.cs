using dt_aareon_emmen.Models.Assets;
using dt_aareon_emmen.Models.Assets.Handlers;
using dt_aareon_emmen.Models.Assets.Handlers.dt_aareon_emmen.Models.Assets.Handlers;
using dt_aareon_emmen.Models.Assets.NewFolder;
using dt_aareon_emmen.Models.Assets.Requirements;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Net.Http.Headers;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();
builder.Services.AddHttpContextAccessor();
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromSeconds(18000);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false;
        options.SaveToken = true;

        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
        };
    });

builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
builder.Services.AddSingleton<IAuthorizationHandler, MfaHandler>();
builder.Services.AddSingleton<IAuthorizationHandler, RoleHandler>();
builder.Services.AddSingleton<IAuthorizationHandler, LoginHandler>();

builder.Services.AddAuthorization(options =>
{
    options.DefaultPolicy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();

    // Policy for when 2 factor auth has been done, on all pages after 2 facor
    options.AddPolicy("mfa", policy =>
    {
        policy.Requirements.Add(new MfaRequirement(true));
    });

    options.AddPolicy("mfaAndLogin", policy =>
    {
        policy.Requirements.Add(new MfaRequirement(false));
    });

    // policy for an user that has just logged in
    options.AddPolicy("login", policy =>
    {
        policy.Requirements.Add(new LoginRequirement("string"));
    });

    // -- start roles -- //
    // Policy for an admin user
    options.AddPolicy("Admin", policy =>
    {
        policy.Requirements.Add(new RoleRequirement(2));
    });

    // -- end roles -- //
});
WebApplication app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseSession();

app.Use(async (context, next) =>
{
    string token = context.Session.GetString("Token");
    if (!string.IsNullOrEmpty(token))
    {
        context.Request.Headers.Add("Authorization", "Bearer " + token);
    }
    await next();
});

app.UseStatusCodePages(async context => {
    
    if (context.HttpContext.Response.StatusCode == 401)
    {
        
        if (string.IsNullOrEmpty(context.HttpContext.Session.GetString("MfaToken")))
        {
            context.HttpContext.Response.Redirect("/Login");
        }
        
        if(!string.IsNullOrEmpty(context.HttpContext.Session.GetString("MfaToken")))
        {
            context.HttpContext.Response.Redirect("/Building");
        }
        
    }
});

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();
});

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Login}/{action=Index}/{id?}");

app.Run();