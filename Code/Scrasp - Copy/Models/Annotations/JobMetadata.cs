using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class JobMetadata {
        [Display(Name = "Description du job")]
        public object jobDescription { get; set; }

        [Display(Name = "Date début")]
        public object startDate { get; set; }

        [Display(Name = "Date fin")]
        public object endDate { get; set; }
    }

    [MetadataType(typeof(JobMetadata))]
    public partial class Job { }
}