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

    public partial class Job {
        public int id { get; set; }
        public string jobDescription { get; set; }
        public Nullable<System.DateTime> startDate { get; set; }
        public Nullable<System.DateTime> endDate { get; set; }
        public int JobStates_id { get; set; }
        public Nullable<int> Stories_id { get; set; }
        public Nullable<int> ScraspUsers_id { get; set; }

        public virtual JobState JobState { get; set; }
        public virtual ScraspUser ScraspUser { get; set; }
        public virtual Story Story { get; set; }
    }
}