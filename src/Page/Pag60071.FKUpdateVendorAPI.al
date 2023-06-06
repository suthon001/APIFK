page 60071 "FK Update Vendor API"
{
    APIGroup = 'bc';
    APIPublisher = 'freshket';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Vendor API';
    DelayedInsert = true;
    EntityName = 'updatevendor';
    EntitySetName = 'updatevendors';
    PageType = API;
    SourceTable = "Vendor Buffer";
    DeleteAllowed = false;
    ODataKeyFields = "No.";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
                field(supplierEngName; Rec."Supplier Eng Name")
                {
                    Caption = 'Supplier Eng Name';
                }
                field(searchName; Rec."Search Name")
                {
                    Caption = 'Search Name';
                }
                field(vendorNoIntranet; Rec."Vendor No. Intranet")
                {
                    Caption = 'Vendor No. Intranet';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(contactName; Rec.Contact)
                {
                    Caption = 'Contact Name';
                }
                field(billingAddress; Rec."Billing Address")
                {
                    Caption = 'Billing Address';
                }
                field(billingAddress2; Rec."Billing Address 2")
                {
                    Caption = 'Billing Address 2';
                }
                field(billingCity; Rec."Billing City")
                {
                    Caption = 'Billing City';
                }
                field(billingPostCode; Rec."Billing Post Code")
                {
                    Caption = 'Billing Post Code';
                }
                field(billingRegionCode; Rec."Billing Region Code")
                {
                    Caption = 'Billing Country/Region Code';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                field(userName; Rec.User_Name)
                {
                    Caption = 'User_Name';
                }
                field(vatRegistrationSupplier; Rec."VAT registration supplier")
                {
                    Caption = 'VAT registration supplier';
                }
                field(companyType; Rec."Company Type")
                {
                    Caption = 'Company Type';
                }
                field(vendorDirect; Rec."Vendor Direct")
                {
                    Caption = 'Vendor Direct';
                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
    begin
        FKFunc.APITempToTable(Database::vendor, page::"FK Vendor API", Rec, rec."No.", 1, 'VENDOR');
    end;
}
