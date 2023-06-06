/// <summary>
/// TableExtension FK API Vendor (ID 60050) extends Record Vendor.
/// </summary>
tableextension 60050 "FK API Vendor" extends Vendor
{
    fields
    {
        field(60050; "Supplier Eng Name"; Text[100])
        {
            Caption = 'Supplier Eng Name';
            DataClassification = CustomerContent;
        }
        field(60051; "Vendor No. Intranet"; Code[20])
        {
            Caption = 'Vendor No. Intranet';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            var
                ltVend: Record Vendor;
            begin
                if xrec."Vendor No. Intranet" <> rec."Vendor No. Intranet" then
                    if rec."Vendor No. Intranet" <> '' then begin
                        ltVend.reset();
                        ltVend.SetRange("No.", '<>%1', rec."No.");
                        ltVend.SetRange("Vendor No. Intranet", rec."Vendor No. Intranet");
                        if ltVend.FindFirst() then
                            ltVend.FieldError("Vendor No. Intranet", 'already exists');
                    end;
            end;
        }
        field(60052; "Billing Address"; Text[100])
        {
            Caption = 'Billing Address';
            DataClassification = CustomerContent;
        }
        field(60053; "Billing Address 2"; Text[50])
        {
            Caption = 'Billing Address 2';
            DataClassification = CustomerContent;

        }
        field(60054; "Billing City"; Text[30])
        {
            Caption = 'Billing City';
            TableRelation = IF ("Billing Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Billing Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Billing Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ltBillingCity, ltCounty : text;
            begin
                ltBillingCity := rec."Billing City";
                ltCounty := rec.County;
                PostCode.LookupPostCode(ltBillingCity, "Billing Post Code", ltCounty, "Billing Region Code");
                rec."Billing City" := CopyStr(ltBillingCity, 1, 30);
                rec.County := CopyStr(ltCounty, 1, 30);

            end;

            trigger OnValidate()
            begin

                PostCode.ValidateCity("Billing City", "Billing Post Code", County, "Billing Region Code", (CurrFieldNo <> 0) and GuiAllowed);


            end;
        }
        field(60055; "Billing Post Code"; code[20])
        {
            Caption = 'Billing Post Code';
            TableRelation = IF ("Billing Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Billing Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Billing Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ltBillingCity, ltCounty : text;
            begin
                ltBillingCity := rec."Billing City";
                ltCounty := rec.County;

                PostCode.LookupPostCode(ltBillingCity, "Billing Post Code", ltCounty, "Billing Region Code");
                rec."Billing City" := CopyStr(ltBillingCity, 1, 30);
                rec.County := CopyStr(ltCounty, 1, 30);

            end;

            trigger OnValidate()
            begin

                PostCode.ValidatePostCode("Billing City", "Billing Post Code", County, "Billing Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;
        }
        field(60056; "Billing Region Code"; code[10])
        {
            Caption = 'Billing Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ltBillingCity, ltCounty : text;
            begin
                ltBillingCity := rec."Billing City";
                ltCounty := rec.County;
                PostCode.CheckClearPostCodeCityCounty(ltBillingCity, "Billing Post Code", ltCounty, "Billing Region Code", xRec."Billing Region Code");
                rec."Billing City" := CopyStr(ltBillingCity, 1, 30);
                rec.County := CopyStr(ltCounty, 1, 30);
            end;
        }
        field(60057; "User_Name"; text[50])
        {
            Caption = 'User_Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ltVend: Record Vendor;
                MailManagement: Codeunit "Mail Management";
            begin
                rec.TestField("BC To INTRANET", false);
                if xrec."User_Name" <> rec."User_Name" then
                    if rec."User_Name" <> '' then begin
                        MailManagement.CheckValidEmailAddresses("User_Name");

                        ltVend.reset();
                        ltVend.SetRange("No.", '<>%1', rec."No.");
                        ltVend.SetRange("User_Name", rec."User_Name");
                        if ltVend.FindFirst() then
                            ltVend.FieldError("User_Name", 'already exists');
                    end;
            end;
        }
        field(60058; "VAT registration supplier"; Boolean)
        {
            Caption = 'VAT registration supplier';
            DataClassification = CustomerContent;
        }
        field(60059; "Company Type"; Boolean)
        {
            Caption = 'Company Type';
            DataClassification = CustomerContent;
        }
        field(60060; "Vendor Direct"; Boolean)
        {
            Caption = 'Vendor Direct';
            DataClassification = CustomerContent;
        }
        field(60061; "TPP Default Address"; Boolean)
        {
            Caption = 'Default Address';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if xrec."TPP Default Address" <> rec."TPP Default Address" then
                    if rec."TPP Default Address" then
                        CopyAddresstoBillingAddress()
                    else begin
                        rec."Billing Address" := '';
                        rec."Billing Address 2" := '';
                        rec."Billing City" := '';
                        rec."Billing Post Code" := '';
                        rec."Billing Region Code" := '';
                    end;
            end;
        }
        field(69998; "BC To INTRANET"; Boolean)
        {
            Caption = 'BC To INTRANET';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(69999; "Is Successfully"; Boolean)
        {
            Caption = 'Is Successfully';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
    trigger OnInsert()
    begin
        if not (CurrentClientType in [CurrentClientType::Api, CurrentClientType::OData, CurrentClientType::ODataV4]) then
            rec."Is Successfully" := true;
    end;

    local procedure CopyAddresstoBillingAddress()
    begin
        rec."Billing Address" := rec.Address;
        rec."Billing Address 2" := rec."Address 2";
        rec."Billing City" := rec.City;
        rec."Billing Post Code" := rec."Post Code";
        rec."Billing Region Code" := rec."Country/Region Code";
    end;

    var
        PostCode: Record "Post Code";
}
