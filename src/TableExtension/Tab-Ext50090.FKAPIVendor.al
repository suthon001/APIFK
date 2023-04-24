/// <summary>
/// TableExtension FK API Vendor (ID 50090) extends Record Vendor.
/// </summary>
tableextension 50090 "FK API Vendor" extends Vendor
{
    fields
    {
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70001; "Supplier Eng Name"; Text[100])
        {
            Caption = 'Supplier Eng Name';
            DataClassification = CustomerContent;
        }
        field(70002; "Vendor No. Intranet"; Code[20])
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
        field(70003; "Billing Address"; Text[100])
        {
            Caption = 'Billing Address';
            DataClassification = CustomerContent;
        }
        field(70004; "Billing Address 2"; Text[50])
        {
            Caption = 'Billing Address 2';
            DataClassification = CustomerContent;

        }
        field(70005; "Billing City"; Text[30])
        {
            Caption = 'Billing City';
            TableRelation = IF ("Billing Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Billing Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Billing Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin

                PostCode.LookupPostCode("Billing City", "Billing Post Code", County, "Billing Region Code");


            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin

                PostCode.ValidateCity("Billing City", "Billing Post Code", County, "Billing Region Code", (CurrFieldNo <> 0) and GuiAllowed);


            end;
        }
        field(70006; "Billing Post Code"; code[20])
        {
            Caption = 'Billing Post Code';
            TableRelation = IF ("Billing Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Billing Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Billing Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin


                PostCode.LookupPostCode("Billing City", "Billing Post Code", County, "Billing Region Code");


            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin

                PostCode.ValidatePostCode("Billing City", "Billing Post Code", County, "Billing Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;
        }
        field(70007; "Billing Region Code"; code[10])
        {
            Caption = 'Billing Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty("Billing City", "Billing Post Code", County, "Billing Region Code", xRec."Billing Region Code");
            end;
        }
        field(70008; "User_Name"; text[50])
        {
            Caption = 'User_Name';
            trigger OnValidate()
            var
                ltVend: Record Vendor;
            begin
                if xrec."User_Name" <> rec."User_Name" then
                    if rec."User_Name" <> '' then begin
                        ltVend.reset();
                        ltVend.SetRange("No.", '<>%1', rec."No.");
                        ltVend.SetRange("User_Name", rec."User_Name");
                        if ltVend.FindFirst() then
                            ltVend.FieldError("User_Name", 'already exists');
                    end;
            end;
        }
        field(70009; "VAT registration supplier"; Boolean)
        {
            Caption = 'VAT registration supplier';
            DataClassification = CustomerContent;
        }
        field(70010; "Company Type"; Boolean)
        {
            Caption = 'Company Type';
            DataClassification = CustomerContent;
        }
        field(70011; "Vendor Direct"; Boolean)
        {
            Caption = 'Vendor Direct';
            DataClassification = CustomerContent;
        }
    }
    var
        PostCode: Record "Post Code";
}
