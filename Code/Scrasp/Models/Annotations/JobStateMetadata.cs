using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class JobStateMetadata {
        [Display(Name = "État")]
        public object stateName { get; set; }
        [Display(Name = "Droit de fermeture")]
        public object allowClosure { get; set; }
        [Display(Name = "Caché dans le dashboard")]
        public object hideInDashboard { get; set; }
    }

    [MetadataType(typeof(JobStateMetadata))]
    public partial class JobState { }
}