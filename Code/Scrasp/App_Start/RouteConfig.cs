﻿using System.Web.Mvc;
using System.Web.Routing;

namespace Scrasp
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "API",
                url: "apix/{controller}/{id}",
                defaults: new { controller = "StoriesAPI", action = "GetStory", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Projects", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
