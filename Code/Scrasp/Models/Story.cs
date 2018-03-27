//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------


namespace Scrasp.Models {
    using System;
    using System.Collections.Generic;

    public partial class Story {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage",
            "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Story() {
            this.Jobs = new HashSet<Job>();
        }

        public int id { get; set; }
        public string shortName { get; set; }
        public string actor { get; set; }
        public string storyDescription { get; set; }
        public int StoryTypes_id { get; set; }
        public int StoryStates_id { get; set; }
        public Nullable<int> Sprints_id { get; set; }
        public int Projects_id { get; set; }
        public Nullable<int> points { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage",
            "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Job> Jobs { get; set; }
        public virtual Project Project { get; set; }
        public virtual Sprint Sprint { get; set; }
        public virtual StoryState StoryState { get; set; }
        public virtual StoryType StoryType { get; set; }
    }
}