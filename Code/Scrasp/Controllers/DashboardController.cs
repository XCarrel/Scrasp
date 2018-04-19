using System;
using System.Collections.Generic;
using System.Linq;
using Scrasp.Models;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;

namespace Scrasp.Controllers
{
    public class DashboardController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: Dashboard
        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                String aspNetUserId = System.Web.HttpContext.Current.User.Identity.GetUserId();
                ScraspUser currentUser = db.ScraspUsers.Where(s => s.AspNetUsers_id == aspNetUserId).First();

                DashboardViewModel model = new DashboardViewModel();
                
                model.jobs = currentUser.Jobs.Where(s => s.JobState.hideInDashboard != 1).ToList();
                model.teams = currentUser.Teams.ToList();                
                
                return View(model);
            }
            return RedirectToAction("Index", "Home");
        }
    }
}