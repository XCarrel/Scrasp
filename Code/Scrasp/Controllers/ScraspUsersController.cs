using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Scrasp.Models;

namespace Scrasp.Controllers
{
    public class ScraspUsersController : Controller
    {
        private scraspEntities db = new scraspEntities();

        // GET: ScraspUsers
        public ActionResult Index()
        {
            var scraspUsers = db.ScraspUsers.Include(s => s.ScraspRole);
            return View(scraspUsers.ToList());
        }

        // GET: ScraspUsers/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspUser scraspUser = db.ScraspUsers.Find(id);
            if (scraspUser == null)
            {
                return HttpNotFound();
            }
            return View(scraspUser);
        }

        // GET: ScraspUsers/Create
        public ActionResult Create()
        {
            ViewBag.ScraspRoles_id = new SelectList(db.ScraspRoles, "id", "roleName");
            return View();
        }

        // POST: ScraspUsers/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,AspNetUsers_id,username,ScraspRoles_id")] ScraspUser scraspUser)
        {
            if (ModelState.IsValid)
            {
                db.ScraspUsers.Add(scraspUser);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.ScraspRoles_id = new SelectList(db.ScraspRoles, "id", "roleName", scraspUser.ScraspRoles_id);
            return View(scraspUser);
        }

        // GET: ScraspUsers/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspUser scraspUser = db.ScraspUsers.Find(id);
            if (scraspUser == null)
            {
                return HttpNotFound();
            }
            ViewBag.ScraspRoles_id = new SelectList(db.ScraspRoles, "id", "roleName", scraspUser.ScraspRoles_id);
            return View(scraspUser);
        }

        // POST: ScraspUsers/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,AspNetUsers_id,username,ScraspRoles_id")] ScraspUser scraspUser)
        {
            if (ModelState.IsValid)
            {
                db.Entry(scraspUser).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.ScraspRoles_id = new SelectList(db.ScraspRoles, "id", "roleName", scraspUser.ScraspRoles_id);
            return View(scraspUser);
        }

        // GET: ScraspUsers/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ScraspUser scraspUser = db.ScraspUsers.Find(id);
            if (scraspUser == null)
            {
                return HttpNotFound();
            }
            return View(scraspUser);
        }

        // POST: ScraspUsers/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            ScraspUser scraspUser = db.ScraspUsers.Find(id);
            db.ScraspUsers.Remove(scraspUser);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
