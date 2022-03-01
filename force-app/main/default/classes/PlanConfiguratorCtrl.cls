public with sharing class PlanConfiguratorCtrl {

    public String basePlan {get;set;}
    public String planFamily {get;set;}
    public String rider {get;set;}
    public String riderBenifit {get;set;}
    
    public list < Plan_Family__c > PlanFamilies;
    public list < Plan_Component__c > BasePlans;
    public list < Plan_Component__c > RiderPlans;
    public list < Benefit > RiderBenefits {get;set;}
    public list < Benefit > ConfiguredBenefits {get;set;}
    //public string SelectedPlanFamily {get;set;}
    //public string SelectedBasePlan {get;set;}
    //public string SelectedRiderPlan {get;set;}
    public Boolean showCBTable{get;set;}
    public Boolean showRBTable{get;set;}
    
    class Benefit {
        public boolean Selected {get;set;}
        public string Plan {get;set;}
        public string Benefit {get;set;}
        public string InNetwork {get;set;}
        public string OutNetwork {get;set;}
        public string AddInfo{get;set;}
        private Plan_Benefits__c m_PlanBenefit;
        public Benefit(){
        }
        public Benefit(string aPlan, Plan_Benefits__c aPlanBenefit) {
            Plan = aPlan;
            m_PlanBenefit = aPlanBenefit;
        }
    }
    public PlanConfiguratorCtrl() {
        showCBTable =false;
        PlanFamilies = [SELECT Id, Name FROM Plan_Family__c limit 100];
    }
    //populate BasePlanse based on SelectedPlanFamily
    public PageReference PopulateBasePlans() {
        BasePlans = [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c = : true AND Product_Component_Type__c != 'Rider'
            limit 100
        ];
        return null;
    }
    //populate RiderPlans based on SelectedPlanFamily   
    public PageReference PopulatePlanBenefits() {
        RiderPlans = [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c = : false AND Product_Component_Type__c = : 'Rider'
            limit 100
        ];
        return null;
    }
    //populate Benefits based on SelectedRiderPlan
    public PageReference SelectedRiderPlan() {
        RiderBenefits.clear();
        Plan_Component__c selectedPlanRider = null; //get the selected rider from RiderPlans using SelectedRiderPlan
        //loop through selectedPlanRider.Plan_Benefits__r to create a list of RiderBenefit
        return null;
    }
    public List <SelectOption> getPlanFamilies() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        for (Plan_Family__c planFamily: [SELECT Id, Name FROM Plan_Family__c limit 100]) {
            options.add(new SelectOption(planFamily.Id, planFamily.Name));
        }
        return options;
    }
    public List < SelectOption > getBasePlans() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        for (Plan_Component__c planComponent: [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c = : true AND Product_Component_Type__c != 'Rider' AND Plan_Family__c=:planFamily
                limit 100
            ]) {
            options.add(new SelectOption(planComponent.Id, planComponent.Name));
        }
        return options;
    }
    public List < SelectOption > getRiders() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        for (Plan_Component__c planComponent: [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c = : false AND Product_Component_Type__c = : 'Rider' AND Plan_Family__c=:planFamily
                limit 100
            ]) {
            options.add(new SelectOption(planComponent.Id, planComponent.Name));
        }
        return options;
    }
    public List < SelectOption > getRiderBenifits() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        for (Plan_Component__c planComponent: [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c = : true AND Product_Component_Type__c != 'Rider'
                limit 100
            ]) {
            options.add(new SelectOption(planComponent.Id, planComponent.Name));
        }
        return options;
    }
    public void changePlanFamily(){
        System.debug('## planFamily '+planFamily);  
    }
    public void chooseBaseFamily(){
        System.debug('## basePlan '+basePlan);
        List<Plan_Benefits__c> lstBaseBenefits =[SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name,Plan__r.Name FROM Plan_Benefits__c WHERE Plan__c =:basePlan];
        ConfiguredBenefits = new List<Benefit>();
        if(!lstBaseBenefits.isEmpty()){
            for(Plan_Benefits__c bens: lstBaseBenefits){
                Benefit cb  = new Benefit();
                cb.selected = false;
                cb.Plan = bens.Plan__r.Name ;
                cb.Benefit = bens.Name ;
                cb.InNetwork = bens.Value__r.In_Network_Display_Value__c ;
                cb.OutNetwork =  bens.Value__r.Out_Of_Network_Display_Value__c ;
                ConfiguredBenefits.add(cb);
            }   
        }
        showCBTable = true;
    }
    public void chooseRiderFamily(){
        System.debug('## rider '+rider);
        RiderBenefits= new List<Benefit>();
        List<Plan_Benefits__c> lstBaseBenefits =[SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name,Plan__r.Name FROM Plan_Benefits__c WHERE Plan__c =:rider];
        if(!lstBaseBenefits.isEmpty()){
            for(Plan_Benefits__c bens: lstBaseBenefits){
                Benefit cb  = new Benefit();
                cb.selected = false;
                cb.Plan = bens.Plan__r.Name ;
                cb.Benefit = bens.Name ;
                cb.InNetwork = bens.Value__r.In_Network_Display_Value__c ;
                cb.OutNetwork =  bens.Value__r.Out_Of_Network_Display_Value__c ;
                RiderBenefits.add(cb);
            }   
        }
        showRBTable = true;
    }
    public void addPlan(){
        System.debug('RiderBenefits '+JSON.serialize(RiderBenefits));
        for(Integer i= 0 ; i < RiderBenefits.size(); i++){
            if(RiderBenefits[i].selected){
                ConfiguredBenefits.add(RiderBenefits[i]);
                RiderBenefits.remove(i);
            }
        }
    }
}