using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class JobStateMetadata
    {
        public object id { get; set; }
        [Display(Name = "État")]
        public object stateName { get; set; }
    }
    [MetadataType(typeof(JobStateMetadata))]
    public partial class JobState
    {

    }
}