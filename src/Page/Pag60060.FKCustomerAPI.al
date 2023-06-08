page 60060 "FK Customer API"
{
    APIGroup = 'bc';
    APIPublisher = 'freshket';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Customer API';
    DelayedInsert = true;
    EntityName = 'createcustomer';
    EntitySetName = 'createcustomers';
    PageType = API;
    SourceTable = "Customer Buffer";
    DeleteAllowed = false;
    ModifyAllowed = false;
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
                        gvJsonObject.Add('no', Rec."No.");
                    end;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('name', Rec."name");
                    end;
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('name2', Rec."Name 2");
                    end;
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('address', Rec."Address");
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
                    Caption = 'Phone No.';
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
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('phoneNo', Rec."Phone No.");
                    end;
                }
                field(creditLimitLCY; Rec."Credit Limit (LCY)")
                {
                    Caption = 'Credit Limit (LCY)';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('creditLimitLCY', Rec."Credit Limit (LCY)");
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
                field(paymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('paymentTermsCode', Rec."Payment Terms Code");
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
                field(customerPostingGroup; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('customerPostingGroup', Rec."Customer Posting Group");
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
                field(vatBusPostingGroup; Rec."VAT Bus. Posting Group")
                {
                    Caption = 'VAT Bus. Posting Group';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatBusPostingGroup', Rec."VAT Bus. Posting Group");
                    end;
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('eMail', Rec."E-Mail");
                    end;
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('contact', Rec.Contact);
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
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
    begin
        FKFunc.APITempToTable(Database::customer, page::"FK Update Customer API", Rec, rec."No.", 0, 'CUSTOMER', gvJsonObject);
    end;

    var
        gvJsonObject: JsonObject;
}
