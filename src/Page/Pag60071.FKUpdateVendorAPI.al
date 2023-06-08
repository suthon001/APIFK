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
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('no', rec."No.");
                    end;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('name', rec."name");
                    end;
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('name2', rec."name 2");
                    end;
                }
                field(searchNameEn; Rec."Supplier Eng Name")
                {
                    Caption = 'Search Name (EN)';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('searchNameEn', Rec."Supplier Eng Name");
                    end;
                }
                field(searchName; Rec."Search Name")
                {
                    Caption = 'Search Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('searchName', Rec."Search Name");
                    end;
                }
                field(vendorNoIntranet; Rec."Vendor No. Intranet")
                {
                    Caption = 'Vendor No. Intranet';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vendorNoIntranet', Rec."Vendor No. Intranet");
                    end;
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('address', Rec.Address);
                    end;
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('address2', Rec."Address 2");
                    end;
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('city', Rec.City);
                    end;
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('postCode', Rec."Post Code");
                    end;
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('countryRegionCode', Rec."Country/Region Code");
                    end;
                }
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatBusPostingGroup', Rec."VAT Bus. Posting Group");
                    end;
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vendorPostingGroup', Rec."Vendor Posting Group");
                    end;
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('genBusPostingGroup', Rec."Gen. Bus. Posting Group");
                    end;
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatRegistrationNo', Rec."VAT Registration No.");
                    end;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('currencyCode', Rec."Currency Code");
                    end;
                }
                field(contactName; Rec.Contact)
                {
                    Caption = 'Contact Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('contactName', Rec.Contact);
                    end;
                }
                field(billingAddress; Rec."Billing Address")
                {
                    Caption = 'Billing Address';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('billingAddress', Rec."Billing Address");
                    end;
                }
                field(billingAddress2; Rec."Billing Address 2")
                {
                    Caption = 'Billing Address 2';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('billingAddress2', Rec."Billing Address 2");
                    end;
                }
                field(billingCity; Rec."Billing City")
                {
                    Caption = 'Billing City';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('billingCity', Rec."Billing City");
                    end;
                }
                field(billingPostCode; Rec."Billing Post Code")
                {
                    Caption = 'Billing Post Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('billingPostCode', Rec."Billing Post Code");
                    end;
                }
                field(billingRegionCode; Rec."Billing Region Code")
                {
                    Caption = 'Billing Country/Region Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('billingRegionCode', Rec."Billing Region Code");
                    end;
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('phoneNo', Rec."Phone No.");
                    end;
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('mobilePhoneNo', Rec."Mobile Phone No.");
                    end;
                }
                field(userName; Rec.User_Name)
                {
                    Caption = 'User_Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('userName', Rec.User_Name);
                    end;
                }
                field(vatRegistrationSupplier; Rec."VAT registration supplier")
                {
                    Caption = 'VAT registration supplier';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatRegistrationSupplier', Rec."VAT registration supplier");
                    end;
                }
                field(companyType; Rec."Company Type")
                {
                    Caption = 'Company Type';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('companyType', Rec."Company Type");
                    end;
                }
                field(vendorDirect; Rec."Vendor Direct")
                {
                    Caption = 'Vendor Direct';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vendorDirect', Rec."Vendor Direct");
                    end;
                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
        ltVendor: Record Vendor;
    begin
        FKFunc.APITempToTable(Database::vendor, page::"FK Vendor API", Rec, rec."No.", 1, 'VENDOR', gvJsonObject);
        if ltVendor.GET(rec."No.") then
            rec.TransferFields(ltVendor, false);
    end;


    var
        gvJsonObject: JsonObject;
}
