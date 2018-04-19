using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers {
    public class TeamsController : Controller {
        private scraspEntities db = new scraspEntities();

        // GET: team-management
        public ActionResult Management() {
            TeamManagementViewModel model = new TeamManagementViewModel {
                projects = db.Projects.ToList(),
                users = db.ScraspUsers.ToList(),
                teams = db.Teams.ToList()
            };

            return View(model);
        }

        // GET: Teams
        public ActionResult Index() {
            var teams = db.Teams.Include(t => t.Project).Include(t => t.ScraspUser);
            return View(teams.ToList());
        }

        // GET: Teams/Details/5
        public ActionResult Details(int? id) {
            if (id == null) {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Team team = db.Teams.Find(id);
            if (team == null) {
                return HttpNotFound();
            }

            return View(team);
        }

        // GET: Teams/Create
        public ActionResult Create() {
            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title");
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id");
            return View();
        }

        // POST: Teams/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,Projects_id,ScraspUsers_id")]
            Team team) {
            if (ModelState.IsValid) {
                db.Teams.Add(team);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", team.Projects_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", team.ScraspUsers_id);
            return View(team);
        }

        // GET: Teams/Edit/5
        public ActionResult Edit(int? id) {
            if (id == null) {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Team team = db.Teams.Find(id);
            if (team == null) {
                return HttpNotFound();
            }

            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", team.Projects_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", team.ScraspUsers_id);
            return View(team);
        }

        // POST: Teams/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,Projects_id,ScraspUsers_id")]
            Team team) {
            if (ModelState.IsValid) {
                db.Entry(team).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.Projects_id = new SelectList(db.Projects, "id", "title", team.Projects_id);
            ViewBag.ScraspUsers_id = new SelectList(db.ScraspUsers, "id", "AspNetUsers_id", team.ScraspUsers_id);
            return View(team);
        }

        // GET: Teams/Delete/5
        public ActionResult Delete(int? id) {
            if (id == null) {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            Team team = db.Teams.Find(id);
            if (team == null) {
                return HttpNotFound();
            }

            return View(team);
        }

        // POST: Teams/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id) {
            Team team = db.Teams.Find(id);
            db.Teams.Remove(team);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing) {
            if (disposing) {
                db.Dispose();
            }

            base.Dispose(disposing);
        }
    }
}