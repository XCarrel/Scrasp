using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models.Annotations {
    public class UserMetadata {
        public object AspNetUsers_id { get; set; }

        [Display(Name = "Nom d'utilisateur")]
        public object username { get; set; }
    }

    [MetadataType(typeof(UserMetadata))]
    public partial class User { }
}