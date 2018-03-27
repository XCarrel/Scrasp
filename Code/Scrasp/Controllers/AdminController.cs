using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class AdminController : Controller
    {

        private scraspEntities db = new scraspEntities();

        // GET: Admin
        public ActionResult Index() {
            ViewBag.StoryTypes = db.StoryTypes.ToList();
            ViewBag.StoryStates = db.StoryStates.ToList();
            ViewBag.ScraspRoles = db.ScraspRoles.ToList();
            ViewBag.JobStates = db.JobStates.ToList();
            return View();
        }
    }
}