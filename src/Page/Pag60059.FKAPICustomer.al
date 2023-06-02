page 60059 "FK API Customer"
{
    APIGroup = 'bc';
    APIPublisher = 'freshket';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'API Customer';
    DelayedInsert = true;
    EntityName = 'customer';
    EntitySetName = 'customers';
    PageType = API;
    SourceTable = "Customer Buffer";
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
                field(customerpostinggroup; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
            }
        }

    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        FKFunc: Codeunit "FK Func";
    begin
        FKFunc.APITempToTable(Database::customer, page::"FK API Customer", Rec, rec."No.", 0, 'CUSTOMER');
    end;
}
