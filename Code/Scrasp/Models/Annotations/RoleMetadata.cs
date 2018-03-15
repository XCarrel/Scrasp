using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace Scrasp.Models
{
    public class RoleMetadata
    {
        public object id { get; set; }
        [Display(Name = "Nom")]
        public object roleName { get; set; }
    }
    [MetadataType(typeof(RoleMetadata))]
    public partial class ScraspRole
    {

    }
}