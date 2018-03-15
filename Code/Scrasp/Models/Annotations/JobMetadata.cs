using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class JobMetadata
    {

        public int id { get; set; }
        [Display(Name = "Description")]
        public object jobDescription { get; set; }
        [Display(Name = "Date début")]
        public object startDate { get; set; }
        [Display(Name = "Date fin")]
        public object endDate { get; set; }
    }
    [MetadataType(typeof(JobMetadata))]
    public partial class Job
    {

    }
}