using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        // GET: Dashboard
        public ActionResult Index()
        {
            // Prevent none connected users to access page
            if (!Request.IsAuthenticated)
            {
                Response.Redirect("Account/Login");
            }

            return View();
        }
    }
}
