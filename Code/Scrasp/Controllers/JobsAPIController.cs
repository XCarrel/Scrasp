using Scrasp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;

namespace Scrasp.Controllers
{
    public class JobsAPIController : ApiController
    {
        private scraspEntities db = new scraspEntities();

        // GET: api/GetJob/5
        [ResponseType(typeof(Job))]
        public IHttpActionResult GetJob(int id)
        {
            Job job = db.Jobs.Find(id);
            if (job == null)
            {
                return NotFound();
            }
            else
            {
                job.JobState.stateName = "Terminé";
            }
            db.SaveChanges();

            return Ok(job);
        }
    }
}
