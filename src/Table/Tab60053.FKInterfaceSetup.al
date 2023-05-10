table 60053 "FK Interface Setup"
{
    Caption = 'FK Interface Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Item Journal Temp. Name (pos.)"; code[10])
        {
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Item Journal Temp. Name (pos.)';
        }
        field(3; "Item Journal Batch Name (Pos.)"; code[10])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Temp. Name (pos.)"));
            DataClassification = CustomerContent;
            Caption = 'Item Journal Batch Name (Pos.)';
        }
        field(4; "Item Journal Positive Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Positive Path';
        }
        field(5; "Item Journal Pos. Success Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Pos. Success Path';
        }
        field(6; "Item Journal Pos. Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Pos. Error Path';
        }
        field(7; "Item Journal Temp. Name (Neg.)"; code[10])
        {
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Item Journal Temp. Name (Neg.)';
        }
        field(8; "Item Journal Batch Name (Neg.)"; code[10])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Temp. Name (Neg.)"));
            DataClassification = CustomerContent;
            Caption = 'Item Journal Batch Name (Neg.)';
        }
        field(9; "Item Journal Nagative Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Nagative Path';
        }
        field(10; "Item Journal Neg. Success Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Neg. Success Path';
        }
        field(11; "Item Journal Neg. Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Neg. Error Path';
        }

        field(12; "Item Journal Temp. Name (Rec.)"; code[10])
        {
            TableRelation = "Item Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Item Journal Temp. Name (Reclass)';
        }
        field(13; "Item Journal Batch Name (Rec.)"; code[10])
        {
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Item Journal Temp. Name (Rec.)"));
            DataClassification = CustomerContent;
            Caption = 'Item Journal Batch Name (Reclass)';
        }
        field(14; "Item Journal Reclass Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Reclass Path';
        }
        field(15; "Item Journal Rec. Success Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Reclass Success Path';
        }
        field(16; "Item Journal Rec. Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Journal Reclass Error Path';
        }
        field(17; "Cash Receipt Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Path';
        }
        field(18; "Cash Receipt Success Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Success Path';
        }
        field(19; "Cash Receipt Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Error Path';
        }
        field(20; "Cash Receipt Temp. Name"; code[10])
        {
            TableRelation = "Gen. Journal Template";
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Temp. Name';
        }
        field(21; "Cash Receipt Batch Name"; code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Cash Receipt Temp. Name"));
            DataClassification = CustomerContent;
            Caption = 'Cash Receipt Batch Name';
        }

        field(22; "Purchase Order Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Order Path';
        }
        field(23; "Purchase Order Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Order Success Path';
        }
        field(24; "Purchase Order Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Order Error Path';
        }
        field(25; "Purchase Return Order Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Return Order Path';
        }
        field(26; "Purch. Return Order Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Return Order Success Path';
        }
        field(27; "Purch. Return Order Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Return Order Error Path';
        }

        field(28; "Purchase GRN Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase GRN Path';
        }
        field(29; "Purch. GRN Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase GRN Success Path';
        }
        field(30; "Purch. GRN Error Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase GRN Error Path';
        }
        field(31; "Return to ship Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Return to ship Path';
        }
        field(32; "Return to ship Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Return to ship Success Path';
        }
        field(33; "Return to ship Err Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Return to ship Error Path';
        }
        field(34; "Sales Invoice Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Invoice Path';
        }
        field(35; "Sales Invoice Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Invoice Success Path';
        }
        field(36; "Sales Invoice Err Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Invoice Error Path';
        }
        field(37; "Sales Credit Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Credit Path';
        }
        field(38; "Sales Credit Succ. Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Credit Success Path';
        }
        field(39; "Sales Credit Err Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Credit Error Path';
        }

    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
