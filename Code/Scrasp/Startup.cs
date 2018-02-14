using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Scrasp.Startup))]
namespace Scrasp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
