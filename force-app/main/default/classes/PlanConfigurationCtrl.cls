public with sharing class PlanConfigurationCtrl {


    private map<Id,Plan_Family__c> m_PlanFamilyById{get;set;}
    public list<SelectOption> PlanFamilies{get;set;}
    
    private map<Id, Plan_Component__c> m_BasePlanById {get;set;}
    public list<SelectOption> BasePlans{get;set;}
    
    private map<Id, Plan_Component__c> m_RiderPlanById {get;set;}
    public list<SelectOption> RiderPlans{get;set;}
    
    private map<Id, Plan_Benefits__c> m_RiderBenefitById {get;set;}
    public list<Benefit> RiderBenefits{get;set;}
    public list<Benefit> ConfiguredBenefits {get;set;}
    
    public string SelectedPlanFamilyId{get;set;}
    public string SelectedBasePlanId{get;set;}
    public string SelectedRiderPlanId{get;set;}
    
    class Benefit {
        public boolean Selected{get;set;}
        public string Plan {get;set;}
        public string Benefit {get;set;}
        public string InNetwork {get;set;}
        public string OutNetwork {get;set;}
        
        private Plan_Benefits__c m_PlanBenefit;
        
        public Benefit(string aPlan, Plan_Benefits__c aPlanBenefit)
        {
            m_PlanBenefit = aPlanBenefit;
            
            Plan = aPlan;
            Benefit = aPlanBenefit.Value__r.Attribute__r.Name;
            InNetwork = aPlanBenefit.Value__r.In_Network_Display_Value__c;
            OutNetwork = aPlanBenefit.Value__r.Out_Of_Network_Display_Value__c;
        }
    }
    
    public PlanConfigurationCtrl ()
    {
        m_PlanFamilyById = new map<Id, Plan_Family__c>([SELECT Id, Name FROM Plan_Family__c limit 100]);
        PlanFamilies = new list<SelectOption>();
        PlanFamilies.add(new SelectOption('', 'Please Select'));
        
        populateSelectOptions(m_PlanFamilyById, PlanFamilies);
              
    }
    
    private void populateSelectOptions(map<Id, sObject> aMap, list<SelectOption> aOptions)
    {
        for(Id key: aMap.Keyset())
        {
            sObject obj = aMap.get(key);
            aOptions.add(new SelectOption(obj.Id, string.valueOf(obj.get('Name'))));
        }
    }
    
    //populate BasePlanse based on SelectedPlanFamilyId
    public PageReference PopulateBasePlans()
    {
        m_BasePlanById = new map<Id, Plan_Component__c>( [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c =: true AND Product_Component_Type__c !=: 'Rider' AND Plan_Family__c =: SelectedPlanFamilyId limit 100]);   
        BasePlans = new list<SelectOption>();
        
        populateSelectOptions(m_BasePlanById, BasePlans);        
      
        return null;
    }
    
    //populate RiderPlans based on SelectedPlanFamilyId
    public PageReference PopulateRiderPlans()
    {
        m_RiderPlanById = new map<Id, Plan_Component__c>( [SELECT Id, Name, (SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name FROM Benefits__r) FROM Plan_Component__c WHERE Is_Base_Component__c =: false AND Product_Component_Type__c =: 'Rider' AND Plan_Family__c =: SelectedPlanFamilyId limit 100]);   
        RiderPlans = new list<SelectOption>();
        
        populateSelectOptions(m_RiderPlanById, RiderPlans);
 
        return null;
    }
 
    //populate RiderPlans based on SelectedPlanFamilyId   
    public PageReference PopulateBasePlanBenefits()
    {
        Plan_Component__c selectedBasePlan = m_BasePlanById.get(SelectedBasePlanId);
        ConfiguredBenefits = new list<Benefit>();
        
        for(Plan_Benefits__c benefit : selectedBasePlan.Benefits__r)
        {
            Benefit ben = new Benefit(selectedBasePlan.Name, benefit);
            ConfiguredBenefits.add(ben);
        }
        
        //for(Plan_Benefits__c benefit = [SELECT Id, Name,(SELECT Id, Name, Value__r.Name, Value__r.In_Network_Display_Value__c, Value__r.Out_Of_Network_Display_Value__c, Value__r.Attribute__r.Name  FROM Benefits__r)  FROM Plan_Component__c WHERE Is_Base_Component__c =: false AND Product_Component_Type__c=: 'Rider' limit 100];
        
        return null;
    }
    
    //populate Benefits based on SelectedRiderPlan
    public PageReference SelectedRiderPlan()
    {
        RiderBenefits.clear();
        Plan_Component__c  selectedPlanRider = null; //get the selected rider from RiderPlans using SelectedRiderPlan
        //loop through selectedPlanRider.Plan_Benefits__r to create a list of RiderBenefit
        return null;
    }
    
     public PageReference addPlan() {
        return null;
    }


    public PageReference chooseRiderFamily() {
        return null;
    }


    public PageReference chooseBaseFamily() {
        return null;
    }


    public PageReference planFamilyChanged() {
        populateBasePlans();
        populateRiderPlans();
        //RiderBenefits = new list<Benefit>();
        //ConfiguredBenefits = new list<Benefit>();
        return null;
    }


}