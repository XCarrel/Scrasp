using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class APIController : Controller
    {
        private scraspEntities db = new scraspEntities();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public bool addTeam(int project_id, int user_id)
        {
            Team newTeam = new Team();
            newTeam.Projects_id = project_id;
            newTeam.ScraspUsers_id = user_id;
            db.Teams.Add(newTeam);
            db.SaveChanges();
            return true;
        }

        [HttpDelete]
        [ValidateAntiForgeryToken]
        public bool removeTeam(int project_id, int user_id)
        {
            Team team = db.Teams.First(t => t.Projects_id == project_id && t.ScraspUsers_id == user_id);
            foreach (Job job in db.ScraspUsers.Find(user_id).Jobs) {
                if(job.Story != null && job.Story.Projects_id == project_id){
                    return false;
                }
            }
            db.Teams.Remove(team);
            db.SaveChanges();
            return true;
        }
    }
}