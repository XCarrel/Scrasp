using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class SprintMetadata
    {
        [Display(Name ="Numéro de sprint")]
        public object number { get; set; }
        [Display(Name = "Déscription")]
        public object sprintDescription { get; set; }
        [Display(Name = "Date début")]
        public object startDate { get; set; }
        [Display(Name = "Date fin")]
        public object endDate { get; set; }
    }
    [MetadataType(typeof(SprintMetadata))]
    public partial class Sprint { }
}