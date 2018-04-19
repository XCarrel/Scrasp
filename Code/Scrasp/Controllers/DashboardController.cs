using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
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
            ViewBag.projects = new List<Project>();
            ViewBag.jobs = new List<Job>();
            if (User.Identity.IsAuthenticated)
            {
                string userId = User.Identity.GetUserId();
                List<Team> userTeams = db.Teams.Where(d => d.ScraspUser.AspNetUsers_id == userId).ToList();
                foreach(Team team in userTeams)
                {
                    ViewBag.projects.Add(team.Project);
                }
                ViewBag.jobs = db.Jobs.Where(d => d.ScraspUser.AspNetUsers_id == userId).ToList();
            }
            return View();
        }
    }
}