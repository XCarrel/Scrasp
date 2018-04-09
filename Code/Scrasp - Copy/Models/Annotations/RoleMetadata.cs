using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models {
    public class RoleMetadata {
        [Display(Name = "Nom")]
        public object roleName { get; set; }
    }

    [MetadataType(typeof(RoleMetadata))]
    public partial class ScraspRole { }
}