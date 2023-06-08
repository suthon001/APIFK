page 60061 "FK Ship to Address API"
{
    APIGroup = 'bc';
    APIPublisher = 'freshket';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Ship To Address API';
    DelayedInsert = true;
    EntityName = 'createshiptodetail';
    EntitySetName = 'createshiptoaddress';
    PageType = API;
    SourceTable = "Ship-to Address Buffer";
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('customerNo', Rec."Customer No.");
                    end;
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('code', Rec.Code);
                    end;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('name', Rec.Name);
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
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('phoneNo', Rec."Phone No.");
                    end;
                }
                field(faxNo; Rec."Fax No.")
                {
                    Caption = 'Fax No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('faxNo', Rec."Fax No.");
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
                field(vatRegistrationNo; Rec."Vat Registration No.")
                {
                    Caption = 'Vat Registration No.';
                    trigger OnValidate()
                    begin
                        gvJsonObject.Add('vatRegistrationNo', Rec."Vat Registration No.");
                    end;
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
    begin
        FKFunc.APITempToTable(Database::"Ship-to Address", page::"FK Ship to Address API", Rec, rec."Customer No." + ' : ' + rec.Code, 0, 'SHIP TO ADDRESS', gvJsonObject);
    end;

    var
        gvJsonObject: JsonObject;
}
