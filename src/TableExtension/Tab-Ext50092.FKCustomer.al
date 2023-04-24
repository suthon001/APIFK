/// <summary>
/// TableExtension FK Customer (ID 50092) extends Record Customer.
/// </summary>
tableextension 50092 "FK Customer" extends Customer
{
    fields
    {
        field(70000; "Already Send"; Boolean)
        {
            Caption = 'Already Send';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
