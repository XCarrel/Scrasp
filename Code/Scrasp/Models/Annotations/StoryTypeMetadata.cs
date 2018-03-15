using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Scrasp.Models
{
    public class StoryTypeMetadata
    {
        [Display(Name ="Type de story")]
        public object typeName { get; set; }
    }

    [MetadataType(typeof(StoryTypeMetadata))]
    public partial class StoryType { }
}